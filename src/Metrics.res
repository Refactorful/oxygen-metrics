open Signals
open Util
open Fetch

// ---------------------------------------------------------------------------
// Server response types
// ---------------------------------------------------------------------------

@spice
type endpointMetrics = {
  avg_latency: float,
  max_latency: float,
  total_requests: int,
  min_latency: float,
  // Older Oxygen releases don't include this on the top-level `server` stats
  total_errors: option<int>,
  percentile_latency_95th: float,
  error_rate: float,
}

@spice
type metricsResponse = {
  server: endpointMetrics,
  errors: dict<int>,
  endpoints: dict<endpointMetrics>,
  requests_per_minute: array<(string, int)>,
  requests_per_second: array<(string, int)>,
  avg_latency_per_minute: array<(string, float)>,
  avg_latency_per_second: array<(string, float)>,
}

type point = (float, float)
type points = array<point>

let emptyPoints: points = []

let emptyServer: endpointMetrics = {
  avg_latency: 0.0,
  max_latency: 0.0,
  total_requests: 0,
  min_latency: 0.0,
  total_errors: None,
  percentile_latency_95th: 0.0,
  error_rate: 0.0,
}

// ---------------------------------------------------------------------------
// Application state (globally shared signals)
// ---------------------------------------------------------------------------

let server = signal(emptyServer)
let endpoints = signal(Dict.make())
let errors = signal(Dict.make())
let requestsPerSecond = signal(emptyPoints)
let avgLatencyPerSecond = signal(emptyPoints)
let requestsPerMinute = signal(emptyPoints)
let avgLatencyPerMinute = signal(emptyPoints)

// true until the first successful response has been received
let loading = signal(true)
let error = signal(None)

// ---------------------------------------------------------------------------
// API
// ---------------------------------------------------------------------------

/**
  Default base URL of the metrics API. When the dashboard is bundled with
  Oxygen.jl, every occurrence of this path is rewritten by the server to
  `<docs_path>/metrics/`, so requests end up at `<origin>/docs/metrics/data/...`.
  During `vite dev` the same path is proxied to the local Oxygen server (see
  vite.config.js). Embedded hosts override it through `window.OxygenMetrics`
  (see Main.res).
 */
let defaultBasePath = "/df9a0d86-3283-4920-82dc-4555fc0d1d8b/data"

/**
  Appends a fresh response to the accumulator. Server statistics overwrite the
  previous values while timeseries are merged (a timestamp can be sent more
  than once when a bin is still being written to).

  All writes are batched into a single notification so the dashboard renders
  once with a complete snapshot (otherwise the charts mount/update several
  times with partial data, which shows up as a stutter on page load).
 */
let append = (metrics: metricsResponse) => {
  Signals.batch(() => {
    server->set(metrics.server)
    endpoints->set(metrics.endpoints)
    errors->set(metrics.errors)

    requestsPerSecond->set(
      requestsPerSecond->val->mergeTimeseries(metrics.requests_per_second->toPoints(~convert=Int.toFloat)),
    )
    avgLatencyPerSecond->set(
      avgLatencyPerSecond->val->mergeTimeseries(
        metrics.avg_latency_per_second->toPoints(~convert=value => value),
      ),
    )
    requestsPerMinute->set(
      requestsPerMinute->val->mergeTimeseries(metrics.requests_per_minute->toPoints(~convert=Int.toFloat)),
    )
    avgLatencyPerMinute->set(
      avgLatencyPerMinute->val->mergeTimeseries(
        metrics.avg_latency_per_minute->toPoints(~convert=value => value),
      ),
    )
  })
}

let lastTimestamp = () =>
  switch requestsPerSecond->val {
  | [] => "null"
  | values => values->Array.getUnsafe(values->Array.length - 1)->Pair.first->formatUtc
  }

// ---------------------------------------------------------------------------
// Polling hook
// ---------------------------------------------------------------------------

@val external setInterval: (unit => unit, int) => 'id = "setInterval"
@val external clearInterval: 'id => unit = "clearInterval"

/**
  Mirrors the polling loop from the original dashboard: it fetches only the
  timeseries newer than the last timestamp we hold (converted to UTC) and
  restarts whenever the base URL, window, poll toggle or interval change
 */
let usePolling = (~baseUrl: string) => {
  Signals.useSignals()

  let windowValue = AppState.windowValue->val
  let poll = AppState.poll->val
  let interval = AppState.interval->val

  // Guards against overlapping requests (e.g. StrictMode double-mounting or a
  // slow response) so a single polling loop can never stack fetches
  let inFlight = React.useRef(false)

  React.useEffect(() => {
    if !poll {
      None
    } else {
      let load = () =>
        if inFlight.current {
          ()
        } else {
          inFlight.current = true
          Fetch.fetch(baseUrl ++ "/" ++ windowValue ++ "/" ++ lastTimestamp())
          ->Promise.then(Fetch.json)
          ->Promise.then(json => {
            Signals.batch(() => {
              switch json->metricsResponse_decode {
              | Ok(metrics) =>
                append(metrics)
                error->set(None)
              | Error(decodeError) => error->set(Some(decodeError.message))
              }
              loading->set(false)
            })
            inFlight.current = false
            Promise.resolve()
          })
          ->Promise.catch(fetchError => {
            loading->set(false)
            error->set(Some(fetchError->String.make))
            inFlight.current = false
            Promise.resolve()
          })
          ->ignore
        }

      load()
      let intervalId = setInterval(load, interval * 1000)
      Some(() => clearInterval(intervalId))
    }
  }, (baseUrl, windowValue, poll, interval))
}
