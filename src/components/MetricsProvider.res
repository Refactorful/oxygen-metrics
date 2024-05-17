open Util
open Fetch
open ReactQuery

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

let emptyMetrics = {
  server: {
    avg_latency: 0.0,
    max_latency: 0.0,
    total_requests: 0,
    min_latency: 0.0,
    total_errors: 0,
    percentile_latency_95th: 0.0,
    error_rate: 0.0,
  },
  errors: Js.Dict.empty(),
  endpoints: Js.Dict.empty(),
  requests_per_minute: [],
  requests_per_second: [],
  avg_latency_per_minute: [],
  avg_latency_per_second: [],
}

/**
 This function helps flatten our errors data structure into a single object 
 */
let group_errors = errors => flattenEntries(errors, v => v)

/**
 This function helps flatten our endpoints data structure into a single object 
 */
let group_total_requests = endpoints => flattenEntries(endpoints, v => v.total_requests)


let demoData = {
  {
    avg_latency_per_minute: [
      ("2024-05-15T18:03:00.0", 0.3866354624430339),
      ("2024-05-15T18:04:00.0", 0.10736783345540364),
      ("2024-05-15T19:02:00.0", 0.48536062240600586),
      ("2024-05-15T19:24:00.0", 2.0880699157714844),
    ],
    errors: Js.Dict.fromArray([
      ("/metrics/data/null", 1),
      ("/metrics", 1),
      ("/metrics/null", 1),
      ("/", 2),
      ("/add/5/7", 1),
    ]),
    requests_per_minute: [
      ("2024-05-15T18:03:00.0", 9),
      ("2024-05-15T18:04:00.0", 6),
      ("2024-05-15T19:02:00.0", 8),
      ("2024-05-15T19:24:00.0", 1),
    ],
    server: {
      avg_latency: 3.851513067881266,
      max_latency: 192.25788116455078,
      total_requests: 72,
      min_latency: 0.014781951904296875,
      total_errors: 6,
      percentile_latency_95th: 3.091096878051758,
      error_rate: 0.08333333333333333,
    },
    endpoints: Js.Dict.fromArray([
      (
        "/metrics/data/null",
        {
          avg_latency: 0.014781951904296875,
          max_latency: 0.014781951904296875,
          total_requests: 1,
          min_latency: 0.014781951904296875,
          total_errors: 1,
          percentile_latency_95th: 0.014781951904296875,
          error_rate: 1.0,
        },
      ),
      (
        "/metrics",
        {
          avg_latency: 0.10514259338378906,
          max_latency: 0.10514259338378906,
          total_requests: 1,
          min_latency: 0.10514259338378906,
          total_errors: 1,
          percentile_latency_95th: 0.10514259338378906,
          error_rate: 1.0,
        },
      ),
      (
        "/metrics/null",
        {
          avg_latency: 0.08106231689453125,
          max_latency: 0.08106231689453125,
          total_requests: 1,
          min_latency: 0.08106231689453125,
          total_errors: 1,
          percentile_latency_95th: 0.08106231689453125,
          error_rate: 1.0,
        },
      ),
      (
        "/",
        {
          avg_latency: 0.2804994583129883,
          max_latency: 0.48613548278808594,
          total_requests: 2,
          min_latency: 0.07486343383789062,
          total_errors: 2,
          percentile_latency_95th: 0.48613548278808594,
          error_rate: 1.0,
        },
      ),
      (
        "/add/23/7?query=23",
        {
          avg_latency: 0.10704994201660156,
          max_latency: 0.10704994201660156,
          total_requests: 1,
          min_latency: 0.10704994201660156,
          total_errors: 0,
          percentile_latency_95th: 0.10704994201660156,
          error_rate: 0.,
        },
      ),
      (
        "/add/5/7?query=%22asdf%22",
        {
          avg_latency: 3.3519608633858815,
          max_latency: 45.163869857788086,
          total_requests: 14,
          min_latency: 0.0591278076171875,
          total_errors: 0,
          percentile_latency_95th: 45.163869857788086,
          error_rate: 0.,
        },
      ),
      (
        "/add/5/7",
        {
          avg_latency: 192.25788116455078,
          max_latency: 192.25788116455078,
          total_requests: 1,
          min_latency: 192.25788116455078,
          total_errors: 1,
          percentile_latency_95th: 192.25788116455078,
          error_rate: 1.,
        },
      ),
      (
        "/add/23/4534?query=23",
        {
          avg_latency: 0.42282044887542725,
          max_latency: 3.091096878051758,
          total_requests: 16,
          min_latency: 0.08988380432128906,
          total_errors: 0,
          percentile_latency_95th: 3.091096878051758,
          error_rate: 0.,
        },
      ),
      (
        "/add/5/7?query=23",
        {
          avg_latency: 21.09813690185547,
          max_latency: 21.09813690185547,
          total_requests: 1,
          min_latency: 21.09813690185547,
          total_errors: 0,
          percentile_latency_95th: 21.09813690185547,
          error_rate: 0.,
        },
      ),
      (
        "/add/22/7?query=23",
        {
          avg_latency: 0.2762149362003102,
          max_latency: 2.490997314453125,
          total_requests: 34,
          min_latency: 0.08893013000488281,
          total_errors: 0,
          percentile_latency_95th: 2.084970474243164,
          error_rate: 0.,
        },
      ),
    ]),
    avg_latency_per_second: [
      ("2024-05-15T18:03:52.0", 0.7267594337463379),
      ("2024-05-15T18:03:53.0", 0.10522206624348958),
      ("2024-05-15T18:03:55.0", 0.10704994201660156),
      ("2024-05-15T18:03:59.0", 0.1499652862548828),
      ("2024-05-15T18:04:00.0", 0.10881423950195312),
      ("2024-05-15T18:04:01.0", 0.10013580322265625),
      ("2024-05-15T19:02:37.0", 1.0949770609537761),
      ("2024-05-15T19:02:38.0", 0.11959075927734375),
      ("2024-05-15T19:24:18.0", 2.0880699157714844),
    ],
    requests_per_second: [
      ("2024-05-15T18:03:52.0", 4),
      ("2024-05-15T18:03:53.0", 3),
      ("2024-05-15T18:03:55.0", 1),
      ("2024-05-15T18:03:59.0", 1),
      ("2024-05-15T18:04:00.0", 5),
      ("2024-05-15T18:04:01.0", 1),
      ("2024-05-15T19:02:37.0", 3),
      ("2024-05-15T19:02:38.0", 5),
      ("2024-05-15T19:24:18.0", 1),
    ],
  }
}




// Usage
// timeFunction(() => {
//   // Your function here
//   let _ = fillMissingData(~data=demoData.avg_latency_per_second->Belt.List.fromArray, ~unit=1000)

// }) -> Js.log

// Js.log(x)

// array_of_dict(demoData.errors)->Js.log

//  Js.Dict.entries(demoData.errors) -> Js.log

@react.component
let make = (~content: metricsResponse => React.element) => {
  let queryResult = ReactQuery.useQuery({
    queryKey: [],
    queryFn: fetchMetrics,
    refetchInterval: ReactQuery.refetchInterval(#number(3 * 1000)),
    initialData: _ => emptyMetrics,
  })

  switch queryResult {
  | {isLoading: true} => "Loading..."->React.string
  | {data: Some(metrics)} => content(metrics)

  // | {isError: true, error: Value(e)} => e->Js.Json.stringify->React.string
  // | {data: Some(metrics), isLoading: false, isError: false} => content(metrics)
  | _ => `Unexpected error...`->React.string
  }
}
