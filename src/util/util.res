

// Helper function used to round a float to a given number of decimal places
let roundFloat = (value, places) => {
  let multiplier = Js.Math.pow_float(~base=10., ~exp=float_of_int(places))
  Js.Math.round(value *. multiplier) /. multiplier
}

/**
  This function flattens the key-value pairs inside a Js Dictionary
  into two separate arrays, one for keys and one for values
 */
let flattenEntries = (data, strategy) => {
    let keys = ref([])
    let values = ref([])
    Js.Dict.entries(data) -> Belt.Array.forEach(((k, v)) => {
        Belt.Array.push(keys.contents, k)
        Belt.Array.push(values.contents, strategy(v))
    })
    { "keys": keys.contents, "values": values.contents }
}


/*
 This fucntion should fill in missing data in the data array based on the unit provided in ms
 */
let fillMissingData = (
  ~data: list<(string, float)>,
  ~unit=1000,
  ~fillToCurrent=true,
  ~sort=true,
) => {

  let unit = float_of_int(unit)
  let filledRecords = ref([])
  let lastRecordTime = ref(0.0)

  // sort records by timestamp if enabled
  let sortedData = !sort
    ? data
    : Belt.List.sort(data, ((timeA, _), (timeB, _)) => {
        let timestampA = timeA->Js.Date.fromString->Js.Date.getTime->Int.fromFloat
        let timestampB = timeB->Js.Date.fromString->Js.Date.getTime->Int.fromFloat
        timestampA - timestampB
      })

  sortedData->Belt.List.forEachWithIndex((index, (timestamp, value)) => {

    // Convert the timestamp to an epoch
    lastRecordTime := timestamp->Js.Date.fromString->Js.Date.getTime

    // append the record to the filled records
    Belt.Array.push(filledRecords.contents, (lastRecordTime.contents, value))

    // safely access the next record in the list
    switch Belt.List.get(sortedData, index + 1) {
    | Some(nextRecord) => {
        // Get the time of the next record
        let nextTime = nextRecord->fst->Js.Date.fromString->Js.Date.getTime /. unit
        // Fill in the missing data up until the next record
        while lastRecordTime.contents +. unit < nextTime {
          lastRecordTime := lastRecordTime.contents +. unit
          Belt.Array.push(filledRecords.contents, (lastRecordTime.contents, 0.0))
        }
      }
    | None => ()
    }
  })

  // Fill in the missing data up until the current time 
  // (ensure lastrecordtime is not 0.0 and unit is greater than 0.0 to prevent infinite loops)
  if fillToCurrent && lastRecordTime.contents > 0.0 && unit > 0.0 {
    // Make sure we format the current time
    let now = Js.Date.now()
    while lastRecordTime.contents +. unit < now {
      lastRecordTime := lastRecordTime.contents +. unit
      Belt.Array.push(filledRecords.contents, (lastRecordTime.contents, 0.0))
    }
  }

  filledRecords.contents
}

// Helper fuction to simplify the call signature
let fill_data = (data, ~unit=1000) => {
  fillMissingData(~data=data->Belt.List.fromArray, ~unit=unit, ~fillToCurrent=true, ~sort=false)
}

let fill_data_int = (data, ~unit=1000) => {
  let dataFloat = data->Belt.Array.map(((x, y)) => (x, float_of_int(y)))
  fill_data(dataFloat, ~unit=unit)
}

/**
 Converts a JavaScript dictionary into an array of key-value pairs.
 
 This function takes a JavaScript dictionary as input and converts it into an array of key-value pairs.
 It uses the Belt library's Array functions for this process.
 */
let array_of_dict = dict => Js.Dict.entries(dict) 


/**
 Returns the druation of a function in milliseconds
 */
let time_function = (f: unit => unit) => {
  let start = Js.Date.now() 
  f()
  let end = Js.Date.now() 
  end -. start
}

