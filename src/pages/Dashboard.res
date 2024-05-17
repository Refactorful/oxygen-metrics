open Util
open Chakra
open ApexCharts
open ReactIcons
open MetricsProvider
// open BrushChart

// open Store

// let logChecked = (e: ReactEvent.Form.t) => {
//   let value: bool = ReactEvent.Form.target(e)["checked"]
//   Js.log(value)
// }

// module MyChart = {
//   let options = {
//     "chart": {
//       "id": "basic-bar",
//     },
//     "xaxis": {
//       "categories": [1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999],
//     },
//   }

//   let series = [
//     {
//       "name": "series-1",
//       "data": [30, 40, 45, 50, 49, 60, 70, 91],
//     },
//   ]

//   @react.component
//   let make = () => {
//     <BarChart series options width="100%" height="300" />
//   }
// }

// module MyPie = {
//   let series = [44, 55, 41, 17, 15]

//   @react.component
//   let make = () => {
//     <DonutChart series width="100%" height="300" />
//   }
// }

module ChartContainer = {
  @react.component
  let make = (~children, ~title) => {
    <Card>
      <CardHeader>
        <Heading size="sm"> {title} </Heading>
      </CardHeader>
      <CardBody> {children} </CardBody>
    </Card>
  }
}
module Content = {
  @react.component
  let make = (~metrics) => {
    let total_errors = group_errors(metrics.errors)
    let total_requests = group_total_requests(metrics.endpoints)
    let expanded_view = true
    Js.log({"metrics": metrics.requests_per_second})
    <Box>
      <Box>
        <SimpleGrid columns={{"sm": 1, "md": 2, "xl": 3}} spacing="24px">
          <StatContainer
            title="Total Requests"
            value={metrics.server.total_requests->Float.fromInt}
            icon={<CiGlobe size=24 />}
          />
          <StatContainer
            title="Error Rate"
            value={roundFloat(metrics.server.error_rate *. 100.0, 2)}
            icon={<IoWarningOutline size=24 />}
            postfix="%"
          />
          <StatContainer
            title="Avg Latency"
            value={roundFloat(metrics.server.avg_latency, 2)}
            icon={<IoTimerOutline size=24 />}
            postfix=" ms"
          />
          <StatContainer
            title="95th Percentile Latency"
            value={roundFloat(metrics.server.percentile_latency_95th, 2)}
            icon={<IoMdPodium size=24 />}
            postfix=" ms"
          />
          <StatContainer
            title="Min Latency"
            value={roundFloat(metrics.server.min_latency, 2)}
            icon={<RiArrowDownDoubleLine size=24 />}
            postfix=" ms"
          />
          <StatContainer
            title="Max Latency"
            value={roundFloat(metrics.server.max_latency, 2)}
            icon={<RiArrowUpDoubleLine size=24 />}
            postfix=" ms"
          />
        </SimpleGrid>
      </Box>
      <br />
      <Box>
        <SimpleGrid columns={{"md": 1, "xl": 2}} spacing="24px">
          <ChartContainer title="Requests Distribution">
            <DonutChart
              width="100%"
              height="300"
              series={total_requests["values"]}
              options={{
                "labels": total_requests["keys"],
                "stroke": {
                  "show": true,
                  "width": 1, // Width of the stroke
                },
                "legend": {
                  "position": expanded_view ? "right" : "bottom",
                  "labels": {
                    "colors": "black",
                  },
                },
              }}
            />
          </ChartContainer>
          <ChartContainer title="Errors Distribution">
            <DonutChart
              width="100%"
              height="300"
              series={total_errors["values"]}
              options={{
                "labels": total_errors["keys"],
                "stroke": {
                  "show": true,
                  "width": 1, // Width of the stroke
                },
                "legend": {
                  "position": expanded_view ? "right" : "bottom",
                  "labels": {
                    "colors": "black",
                  },
                },
              }}
            />
          </ChartContainer>
          <ChartContainer title="Requests / Second">
            <BrushChart 
              label={"avg-latency-per-second"}
              unit={" ms"}
              range={60_000}
              data={metrics.requests_per_second}
              theme={Light}
              // data={fill_data(metrics.avg_latency_per_second, ~unit=1000)}
              // data={fillDataGaps ? fill_data(avg_latency_per_second) : dict_to_array(avg_latency_per_second)}
            />
          </ChartContainer>
        </SimpleGrid>
      </Box>
    </Box>
  }
}

@react.component
let make = () => {
  <MetricsProvider content={metrics => <Content metrics />} />
}
