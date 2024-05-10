/**
 * This module definition describes how to pass arguments to the ApexCharts library
 */
module ApexChartBase = {
  @react.component @module("react-apexcharts")
  external make: (
    ~\"type"  : string,
    ~series   : array<'a>,
    ~options  : 'b =?,
    ~width    : string =?,
    ~height   : string =?,
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
  let make = (~series,  ~options=?, ~width, ~height) => {
    <ApexChart _type="bar" series options width height />
  }
}

module DonutChart = {
  @react.component
  let make = (~series, ~options=?, ~width, ~height) => {
    <ApexChart _type="donut" series options width height />
  }
}

