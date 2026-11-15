open Chakra
open ApexCharts
open BrushChartOptions
open Util

/**
  A pair of synced ApexCharts: a large line chart on top and an area "brush"
  chart at the bottom. Dragging the brush updates the range of the top chart;
  while a selection is active incoming realtime data is frozen so the selection
  does not jump around.
 */
@react.component
let make = (
  ~data: array<(float, float)>,
  ~label: string,
  ~unit: option<string>=?,
  ~range: option<int>=?,
  ~height="400px",
) => {
  // generate unique labels for each chart
  let chart1 = label ++ "-1"
  let chart2 = label ++ "-2"

  let {colorMode} = Chakra.useColorMode()
  let fillColor = Chakra.useColorModeValue("#24292e", "white")
  let strokeColor = Chakra.useColorModeValue("gray", "white")

  let (chartData, setChartData) = React.useState(() => data)
  let (selection, setSelection) = React.useState(() => None)
  let (chartOptions, setChartOptions) = React.useState(() => getChartOpts(chart2, unit))

  let onBrushUpdate = (event: brushEvent) => {
    let next = {
      range: event.xaxis.max -. event.xaxis.min,
      min: event.xaxis.min,
      max: event.xaxis.max,
    }

    setSelection(_ => Some(next))
    setChartOptions(prev =>
      merge(prev, {
        "xaxis": merge(prev["xaxis"], {"range": next.range, "min": next.min, "max": next.max}),
      })
    )
  }

  let (lineOptions, setLineOptions) = React.useState(() =>
    getLineOpts(chart1, chart2, ~unit, ~fillColor, ~strokeColor, ~onBrushScrolled=onBrushUpdate)
  )

  // keep the top chart data up to date (pause while the user is selecting)
  React.useEffect(() => {
    if selection->Option.isNone {
      setChartData(_ => data)
    }
    None
  }, (data, selection))

  // keep the selection fill/stroke in sync with the color mode
  React.useEffect(() => {
    setLineOptions(prev =>
      merge(prev, {
        "chart": merge(prev["chart"], {
          "selection": merge(prev["chart"]["selection"], {
            "fill": merge(prev["chart"]["selection"]["fill"], {"color": fillColor}),
            "stroke": merge(prev["chart"]["selection"]["stroke"], {"color": strokeColor}),
          }),
        }),
      })
    )
    None
  }, [colorMode])

  // keep the bottom chart range up to date with the selected window
  React.useEffect(() => {
    switch selection {
    | Some(selected) =>
      if data->Array.length > 0 {
        setChartOptions(prev =>
          merge(prev, {
            "xaxis": merge(prev["xaxis"], {
              "range": selected.range,
              "min": selected.min,
              "max": selected.max,
            }),
          })
        )
      }
    | None => ()
    }

    setLineOptions(prev =>
      merge(prev, {"xaxis": merge(prev["xaxis"], {"range": range->Option.getOr(jsUndefined)})})
    )
    None
  }, [range])

  // resets the selection on both charts and goes back to the realtime view
  let clearSelect = () => {
    setSelection(_ => None)

    setLineOptions(prev =>
      merge(prev, {
        "chart": merge(prev["chart"], {
          "selection": merge(prev["chart"]["selection"], {
            "xaxis": {"min": jsUndefined, "max": jsUndefined},
          }),
        }),
      })
    )

    ApexCharts.apexCharts->ApexCharts.exec(
      chart1,
      "updateOptions",
      {"chart": {"selection": {"xaxis": {"min": jsUndefined, "max": jsUndefined}}}},
      false,
      true,
    )

    setChartOptions(prev =>
      merge(prev, {
        "xaxis": merge(prev["xaxis"], {"min": jsUndefined, "max": jsUndefined, "range": 60_000}),
      })
    )

    ApexCharts.apexCharts->ApexCharts.exec(
      chart2,
      "updateOptions",
      merge(chartOptions, {
        "xaxis": merge(chartOptions["xaxis"], {
          "min": jsUndefined,
          "max": jsUndefined,
          "range": 60_000,
        }),
      }),
      false,
      true,
    )
  }

  <Box ps="8px">
    <Box style={{"height": height}}>
      <ApexChart
        _type="line" options=chartOptions series=[{"data": chartData}] width="100%" height="64%"
      />
      <ApexChart
        _type="area" options=lineOptions series=[{"data": chartData}] width="100%" height="36%"
      />
    </Box>
    <Box display="flex" justifyContent="flex-end">
      <Button size="sm" onClick={_ => clearSelect()}> {React.string("reset")} </Button>
    </Box>
  </Box>
}
