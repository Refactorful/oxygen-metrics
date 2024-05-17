open Chakra
open ApexCharts
open BrushChartOptions
open AppState

@react.component
let make = (~data, ~label, ~unit, ~range, ~theme) => {
  // generate unique labels for each chart
  let chart1 = label ++ "-1"
  let chart2 = label ++ "-2"

  let fillColor = switch theme {
  | Light => "#24292e"
  | Dark => "white"
  }

  let strokeColor = switch theme {
  | Light => "gray"
  | Dark => "white"
  }
  
  // initialize the chart options
  let initialChartOptions = getChartOpts(chart2, range, unit)
  let initialLineOptions = getLineOpts(chart1, chart2, unit, fillColor, strokeColor)

  let (chartOptions, _setChartOptions) = React.useState(() => initialChartOptions)
  let (lineOptions, _setLineOptions) = React.useState(() => initialLineOptions)
  // let (chartData, _setChartData) = React.useState(() => data)

  Js.log([{"data": data}])
  <Box style={{height: "400px"}}>
    <ApexChart
      _type="line" options=chartOptions series=[{"data": data}] width="100%" height="70%"
    />
    <ApexChart
      _type="area" options=lineOptions series=[{"data": data}] width="100%" height="30%"
    />
  </Box>
}
