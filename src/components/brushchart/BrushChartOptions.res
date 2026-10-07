/**
  Represents `undefined` so we can mirror the exact option objects the original
  dashboard passes when clearing an ApexCharts axis range
 */
let jsUndefined: 'a = %raw("undefined")

/**
  The value of `w.config.xaxis.range` is only treated as "set" by ApexCharts when
  it is a defined number, so `undefined` restores the automatic range
 */
let countLeadingZeros = (number: float) => {
  let str = Js.Float.toString(number)

  if !Js.String.includes(".", str) {
    3
  } else {
    let decimalPart = Js.String.split(".", str)->Array.get(1)->Option.getOr("")
    let count = ref(2)
    let i = ref(0)
    let len = Js.String.length(decimalPart)
    while i.contents < len && Js.String.get(decimalPart, i.contents) == "0" {
      count := count.contents + 1
      i := i.contents + 1
    }
    count.contents
  }
}

let yaxisFormatter = (value: float, unit: option<string>) => {
  let formatted = if value != Math.floor(value) {
    value->Float.toFixed(~digits=countLeadingZeros(value))
  } else {
    Js.Float.toString(value)
  }

  switch unit {
  | Some(unit) => formatted ++ unit
  | None => formatted
  }
}

/**
  Formats an epoch timestamp as a local time label ("06:03:52 PM"), matching
  the moment.js `hh:mm:ss A` format used by the original dashboard
 */
let timeLabel = (epochMs: float) => {
  let date = Js.Date.fromFloat(epochMs)
  let pad = value => value < 10 ? "0" ++ Int.toString(value) : Int.toString(value)
  let hours = Js.Date.getHours(date)->Int.fromFloat
  let suffix = hours < 12 ? "AM" : "PM"
  let hour12 = if hours == 0 || hours == 12 {
    12
  } else {
    hours - (hours / 12) * 12
  }
  pad(hour12) ++
  ":" ++
  pad(Js.Date.getMinutes(date)->Int.fromFloat) ++
  ":" ++
  pad(Js.Date.getSeconds(date)->Int.fromFloat) ++
  " " ++
  suffix
}

type brushRange = {
  range: float,
  min: float,
  max: float,
}

type brushXAxis = {min: float, max: float}
type brushEvent = {xaxis: brushXAxis}

let labelStyle = {"colors": "#c8cfca", "fontSize": "12px"}

/**
  Options for the main (top) chart which is the target of the brush
 */
let getChartOpts = (label: string, unit: option<string>) => {
  {
    "chart": {
      "id": label,
      "type": "line",
      "toolbar": {
        "autoSelected": "pan",
        "show": false,
        "tools": {
          "zoom": false,
          "zoomin": false,
          "zoomout": false,
          "selection": false,
          "reset": false,
        },
      },
    },
    "tooltip": {"theme": "dark"},
    "stroke": {"width": 2},
    "dataLabels": {"enabled": false},
    "markers": {"size": 0},
    "colors": ["#0BC5EA", "#2D3748"],
    "xaxis": {
      "type": "datetime",
      "range": 60_000,
      "tickAmount": 3,
      "labels": {
        "formatter": (value: float) => timeLabel(value),
        "style": labelStyle,
      },
    },
    "yaxis": {
      "labels": {
        "align": "left",
        "minWidth": 45,
        "style": labelStyle,
        "formatter": (value: float) => yaxisFormatter(value, unit),
      },
    },
  }
}

/**
  Options for the bottom (brush) chart, which controls the range of `target`
 */
let getLineOpts = (
  label: string,
  target: string,
  ~unit: option<string>,
  ~fillColor: string,
  ~strokeColor: string,
  ~onBrushScrolled: brushEvent => unit,
) => {
  {
    "chart": {
      "id": label,
      "height": 130,
      "type": "area",
      "brush": {"target": target, "enabled": true},
      "selection": {
        "enabled": true,
        "fill": {"color": fillColor, "opacity": 0.1},
        "stroke": {"width": 1, "dashArray": 3, "color": strokeColor, "opacity": 1},
      },
      "events": {
        "brushScrolled": (. _chartContext, event: brushEvent) => onBrushScrolled(event),
      },
    },
    "stroke": {"width": 1},
    "colors": ["#0BC5EA", "#2D3748"],
    "xaxis": {
      "type": "datetime",
      "tickAmount": 3,
      "labels": {
        "formatter": (value: float) => timeLabel(value),
        "style": labelStyle,
      },
    },
    "yaxis": {
      "tickAmount": 1,
      "labels": {
        "align": "left",
        "minWidth": 45,
        "style": labelStyle,
        "formatter": (value: float) => yaxisFormatter(value, unit),
      },
    },
  }
}
