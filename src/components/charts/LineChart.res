open Chakra
open ApexCharts
open BrushChartOptions

/**
  The original "LineChartV2": a single area chart with a gradient fill that
  keeps its series in sync with the incoming realtime data
 */
@react.component
let make = (
  ~data: array<(float, float)>,
  ~unit: option<string>=?,
  ~range: option<int>=?,
  ~curve: option<string>=?,
  ~height="300px",
) => {
  let options = {
    "stacked": false,
    "chart": {
      "toolbar": {
        "show": false,
        "tools": {
          "zoom": false,
          "zoomin": false,
          "zoomout": false,
          "pan": false,
          "selection": false,
          "reset": false,
        },
      },
    },
    "tooltip": {"theme": "dark"},
    "dataLabels": {"enabled": false},
    "stroke": {"curve": curve->Option.getOr("smooth")},
    "xaxis": {
      "type": "datetime",
      "tickAmount": 3,
      "range": range->Option.getOr(jsUndefined),
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
    "legend": {"show": false},
    "grid": {"strokeDashArray": 5},
    "fill": {
      "type": "gradient",
      "gradient": {
        "shade": "light",
        "type": "vertical",
        "shadeIntensity": 0.5,
        "inverseColors": true,
        "opacityFrom": 0.8,
        "opacityTo": 0,
        "stops": [],
      },
      "colors": ["#0BC5EA", "#2D3748"],
    },
    "colors": ["#0BC5EA", "#2D3748"],
  }

  let (series, setSeries) = React.useState(() => [{"data": data}])

  React.useEffect(() => {
    setSeries(_ => [{"data": data}])
    None
  }, [data])

  <Box style={{"height": height}} ps="8px">
    <ApexChart _type="area" options series width="100%" height="100%" />
  </Box>
}
