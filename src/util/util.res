/**
  Rounds a float to the given number of decimal places
 */
let roundFloat = (value, places) => {
  let multiplier = Math.pow(10., ~exp=Int.toFloat(places))
  Math.round(value *. multiplier) /. multiplier
}

/**
  Flattens the key-value pairs inside a Js.Dict into an object containing
  a `keys` array and a `values` array
 */
let flattenEntries = (data, strategy) => {
  let keys = ref([])
  let values = ref([])
  Dict.toArray(data)->Belt.Array.forEach(((k, v)) => {
    Belt.Array.push(keys.contents, k)
    Belt.Array.push(values.contents, strategy(v))
  })
  {"keys": keys.contents, "values": values.contents}
}

/**
  Parses a UTC timestamp sent by the Oxygen server (e.g. "2024-05-15T18:03:52.0")
  into an epoch timestamp in milliseconds
 */
let parseUtc = (timestamp: string) => {
  let normalized = Js.String.endsWith(timestamp, "Z") ? timestamp : timestamp ++ "Z"
  Date.fromString(normalized)->Date.getTime
}

/**
  Formats an epoch timestamp in milliseconds as a UTC string matching the format
  expected by the Oxygen `{latest}` route param: "YYYY-MM-DDTHH:mm:ss.0"
 */
let formatUtc = (epochMs: float) => {
  let date = Date.fromTime(epochMs)
  let pad = value => value < 10 ? "0" ++ Int.toString(value) : Int.toString(value)
  let year = Date.getUTCFullYear(date)
  let month = Date.getUTCMonth(date) + 1
  let day = Date.getUTCDate(date)
  let hours = Date.getUTCHours(date)
  let minutes = Date.getUTCMinutes(date)
  let seconds = Date.getUTCSeconds(date)
  Int.toString(year) ++
    "-" ++
    pad(month) ++
    "-" ++
    pad(day) ++
    "T" ++
    pad(hours) ++
    ":" ++
    pad(minutes) ++
    ":" ++
    pad(seconds) ++
    ".0"
}

/**
  Shallow-merges two JS objects into a new object (`Object.assign({}, a, b)`).
  Useful for immutably updating ApexCharts option objects.
 */
let merge: ('a, 'b) => 'a = %raw("(a, b) => Object.assign({}, a, b)")

/**
  Converts a `(timestamp, value)` series coming from the server into `(epochMs, value)` tuples
 */
let toPoints = (data: array<(string, 'value)>, ~convert: 'value => float) =>
  data->Array.map(((timestamp, value)) => (timestamp->parseUtc, value->convert))

/**
  Merges two sorted timeseries together, keeping the last value seen for
  duplicate timestamps (the server can send an update for the latest bin)
 */
let mergeTimeseries = (previous: array<(float, float)>, incoming: array<(float, float)>) => {
  let seen = Dict.make()
  let result = []

  let add = ((timestamp, value)) => {
    let key = Float.toString(timestamp)
    switch Dict.get(seen, key) {
    | Some(index) => result->Array.setUnsafe(index, (timestamp, value))
    | None => {
        Dict.set(seen, key, result->Array.length)
        result->Array.push((timestamp, value))
      }
    }
  }

  previous->Array.forEach(add)
  incoming->Array.forEach(add)
  result
}

/**
  Fills in missing data in a sorted `(epochMs, value)` series based on the unit
  provided in milliseconds. Optionally fills the series up to the current time.
 */
let fillMissingData = (~data: array<(float, float)>, ~unit=1000., ~fillToCurrent=true) => {
  let filledRecords = []
  let lastRecordTime = ref(0.0)

  data->Array.forEachWithIndex(((timestamp, value), index) => {

    // Keep track of the last timestamp we've seen and append the record
    lastRecordTime := timestamp
    filledRecords->Array.push((timestamp, value))

    switch data->Array.get(index + 1) {
    | Some((nextTime, _)) =>
      while lastRecordTime.contents +. unit < nextTime {
        lastRecordTime := lastRecordTime.contents +. unit
        filledRecords->Array.push((lastRecordTime.contents, 0.0))
      }
    | None => ()
    }
  })

  // Fill in the missing data up until the current time
  // (guard against infinite loops when unit is not positive)
  if fillToCurrent && lastRecordTime.contents > 0.0 && unit > 0.0 {
    let now = Date.now()
    while lastRecordTime.contents +. unit < now {
      lastRecordTime := lastRecordTime.contents +. unit
      filledRecords->Array.push((lastRecordTime.contents, 0.0))
    }
  }

  filledRecords
}
