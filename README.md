# Oxygen Metrics Dashboard (ReScript)

ReScript re-write of the [oxygen-metrics-dashboard](../oxygen-metrics-dashboard) React app
that is bundled with [Oxygen.jl](../Oxygen.jl) and served at `GET /docs/metrics`.

## Stack

- [ReScript](https://rescript-lang.org) 12 with `@rescript/react` (JSX v4)
- [Chakra UI](https://chakra-ui.com) 2 for layout/theme + Tailwind for utility classes
- [ApexCharts](https://apexcharts.com) (`react-apexcharts`) for all graphs
- [@preact/signals-react](https://preactjs.com/guide/v10/signals/) as the global store
- [`@mununki/ppx-spice`](https://github.com/mununki/ppx_spice) for JSON decoding

## Development

```sh
bun install
bun run res:dev   # ReScript compiler in watch mode
bun run dev       # Vite dev server
```

The dev server proxies `/df9a0d86-3283-4920-82dc-4555fc0d1d8b/*` to a local Oxygen
server running on `http://127.0.0.1:8080`, so start your Oxygen app with metrics
enabled first:

```julia
using Oxygen
@get "/" do
    "hello"
end
serve(metrics = true)   # http://127.0.0.1:8080/docs/metrics
```

## Bundling into Oxygen.jl

The dashboard is embedded into [Oxygen.jl](../Oxygen.jl) as a bundle:

```sh
bun run bundle   # builds dist-lib/ and copies it into Oxygen.jl/data/dashboard
```

That copies three files into `Oxygen.jl/data/dashboard`:

| File | Purpose |
| --- | --- |
| `index.js` | IIFE bundle registering `window.OxygenMetrics`. |
| `styles.css` | Tailwind base/utilities used by the dashboard. |
| `oxygen-logo.png` | Favicon for the served page. |

Oxygen serves them at `<docs_path>/metrics/` and generates the mount page
(`metricshtml` in `Oxygen.jl/src/autodoc.jl`), which calls
`window.OxygenMetrics` with the runtime docs path. Because the bundle carries
no baked-in paths, custom `docs_path` values and server prefixes work without
any find-and-replace.

The target directory can be overridden with the first argument or the
`OXYGEN_DASHBOARD_DIR` environment variable:

```sh
bun run bundle ../Oxygen.jl/data/dashboard
OXYGEN_DASHBOARD_DIR=../Oxygen.jl/data/dashboard bun run bundle
```

`bun run build` still emits the standalone page in `dist/` (useful for local
testing), but Oxygen no longer serves that output.

## Embedding in another page

`bun run build:lib` emits the same self-contained bundle the Oxygen package
uses:

| File | Purpose |
| --- | --- |
| `dist-lib/index.js` | Registers the callable `window.OxygenMetrics` global. |
| `dist-lib/styles.css` | Tailwind base/utilities used by the dashboard. |

Load both on any page, drop in an empty container, and mount:

```html
<div id="oxygen-metrics" style="height: 100vh"></div>
<link rel="stylesheet" href="/docs/metrics/styles.css" />
<script src="/docs/metrics/index.js"></script>
<script>
  const viewer = window.OxygenMetrics({
    endpoint: "/docs/metrics/data", // base URL of the metrics API
    domId: "oxygen-metrics",        // id of the container element
  });
  // viewer.unmount();
</script>
```

`window.OxygenMetrics.mount(config)` is the same function, and
`window.OxygenMetrics("some-dom-id")` is a shorthand where the string is the
`domId`. Options:

- **`endpoint`** (alias `url`): base URL of the metrics API, absolute or
  same-origin. Defaults to the standalone/dev path that `vite dev` proxies to
  the local Oxygen server; embedded hosts pass their own.
- **`domId`** (alias `dom_id`): id of an empty container element. Defaults to
  `"oxygen-metrics"`.

The mount returns an `{ unmount }` handle.

Notes:

- `styles.css` includes Tailwind's preflight, which applies page-wide.
- The embed does not bundle the Roboto webfonts; load Roboto yourself (e.g.
  `@fontsource/roboto`) for the exact typeface, otherwise the theme falls back
  to `sans-serif`.
- Give the container a height (e.g. `100vh`) since the dashboard fills the
  viewport.
- The two files are all that is needed, so they can be served from any static
  host or CDN, or from Oxygen itself (`<docs_path>/metrics/index.js`).

## How realtime updates work

`Metrics.usePolling()` (called once in `App.res`) mirrors the original
`layouts/Admin.js` loop:

1. Read the newest timestamp held in the `requests_per_second` signal and format
   it as a UTC string (`YYYY-MM-DDTHH:mm:ss.0`).
2. Fetch `<base>/<window>/<latest>` — the first request uses `null` to pull the
   initial window.
3. Convert incoming UTC timestamps to local epoch milliseconds, merge them into
   the accumulated series (last value wins for duplicate bins) and overwrite the
   server/endpoints/errors aggregates.
4. Restart the loop whenever the window, poll toggle or interval change.

`BrushChart` freezes the top chart while a brush selection is active and resumes
on `reset`, just like the original implementation.
