/**
 * This module definition describes how to pass arguments to the ApexCharts library
 */
module ApexChartBase = {
  @react.component @module("react-apexcharts")
  external make: (
    ~\"type": string,
    ~series: array<'series>,
    ~options: 'options=?,
    ~width: string=?,
    ~height: string=?,
  ) => React.element = "default"
}

/**
 * This module definition wraps the ApexChartBase module and provides a more user-friendly interface
 */
module ApexChart = {
  @react.component
  let make = (~_type, ~series, ~options=?, ~width, ~height) => {
    <ApexChartBase \"type"=_type series options width height />
  }
}

module BarChart = {
  @react.component
  let make = (~series, ~options=?, ~width, ~height) => {
    <ApexChart _type="bar" series options width height />
  }
}

module DonutChart = {
  @react.component
  let make = (~series, ~options=?, ~width, ~height) => {
    <ApexChart _type="donut" series options width height />
  }
}

/**
 * Access to the static `ApexCharts.exec(chartId, method, ...args)` helper, used to
 * imperatively reset the brush selection of a synced chart pair
 */
type apexCharts

@module("apexcharts") external apexCharts: apexCharts = "default"
@send external exec: (apexCharts, string, string, 'options, bool, bool) => unit = "exec"
