open Chakra
open ApexCharts
open ReactIcons
open Fetch
open ReactQuery

// open Store

// let logChecked = (e: ReactEvent.Form.t) => {
//   let value: bool = ReactEvent.Form.target(e)["checked"]
//   Js.log(value)
// }


@spice
type endpointMetrics = {
  avg_latency: float,
  max_latency: float,
  total_requests: int,
  min_latency: float,
  total_errors: int,
  percentile_latency_95th: float,
  error_rate: float,
}

@spice
type metricsResponse = {
  server: endpointMetrics,
  errors: Js.Dict.t<int>,
  endpoints: Js.Dict.t<endpointMetrics>,
  requests_per_minute: array<(string, int)>,
  requests_per_second: array<(string, int)>,
  avg_latency_per_minute: array<(string, float)>,
  avg_latency_per_second: array<(string, float)>,
}

let apiUrl = "http://127.0.0.1:8080/docs/metrics/data/60/null"

let fetchMetrics = (_): Js.Promise.t<metricsResponse> => {
  Fetch.fetch(apiUrl)->Promise.then(Fetch.json)
}

module MyChart = {
  let options = {
    "chart": {
      "id": "basic-bar",
    },
    "xaxis": {
      "categories": [1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999],
    },
  }

  let series = [
    {
      "name": "series-1",
      "data": [30, 40, 45, 50, 49, 60, 70, 91],
    },
  ]

  @react.component
  let make = () => {
    <BarChart series options width="100%" height="300" />
  }
}

module MyPie = {
  let series = [44, 55, 41, 17, 15]

  @react.component
  let make = () => {
    <DonutChart series width="100%" height="300" />
  }
}


module Content = {
  @react.component
  let make = (~metrics) => {
    <div>
      // <div>
      //   <h1> {metrics.server.avg_latency->Float.toString->React.string} </h1>
      //   <p> {metrics.server.total_requests->Int.toString->React.string} </p>
      //   <div>
      //     {metrics.avg_latency_per_second
      //     ->Belt.Array.map(((timestamp, avg_latency)) => {
      //       <div key={timestamp}>
      //         <p> {timestamp->React.string} </p>
      //         <p> {avg_latency->Float.toString->React.string} </p>
      //       </div>
      //     })
      //     ->React.array}
      //   </div>
      // </div>
      <Box>
        <SimpleGrid columns={{"sm": 1, "md": 2, "xl": 3}} spacing="24px">
          <StatContainer title="Total Requests" value=52343. icon={<CiGlobe size=24 />} />
          <StatContainer title="Error Rate" value=52343. icon={<IoWarningOutline size=24 />} />
          <StatContainer title="Avg Latency" value=52343. icon={<IoTimerOutline size=24 />} />
          <StatContainer
            title="95th Percentile Latency" value=52343. icon={<IoMdPodium size=24 />}
          />
          <StatContainer
            title="Min Latency" value=52343. icon={<RiArrowDownDoubleLine size=24 />}
          />
          <StatContainer title="Max Latency" value=52343. icon={<RiArrowUpDoubleLine size=24 />} />
        </SimpleGrid>
      </Box>
      <br />
      <Box>
        <SimpleGrid columns={{"md": 1, "xl": 2}} spacing="24px">
          <Card>
            <CardBody>
              <MyPie />
            </CardBody>
          </Card>
          <Card>
            <CardBody>
              <MyChart />
            </CardBody>
          </Card>
          <Card>
            <CardBody>
              <MyChart />
            </CardBody>
          </Card>
          <Card>
            <CardBody>
              <MyPie />
            </CardBody>
          </Card>
          <Card>
            <CardBody>
              <MyPie />
            </CardBody>
          </Card>
          <Card>
            <CardBody>
              <MyChart />
            </CardBody>
          </Card>
        </SimpleGrid>
      </Box>
    </div>
  }
}

@react.component
let make = () => {

  // setup our recurring api query
  let queryResult = ReactQuery.useQuery({
    queryKey: [],
    queryFn: fetchMetrics,
    refetchInterval: ReactQuery.refetchInterval(#number(3 * 1000)),
  })

  <div className="p-6">
    {switch queryResult {
    | {isLoading: true} => "Loading..."->React.string
    | {isError: true, error: Value(e)} => e->Js.Json.stringify->React.string
    | {data: Some(metrics), isLoading: false, isError: false} => <Content metrics/>
    | _ => `Unexpected error...`->React.string
    }}
  </div>
}
