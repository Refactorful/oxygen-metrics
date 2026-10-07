# Oxygen Metrics Dashboard (ReScript)

ReScript re-write of the [oxygen-metrics-dashboard](../oxygen-metrics-dashboard) React app
that is bundled with [Oxygen.jl](../Oxygen.jl) and served at `GET /docs/metrics`.

## Stack

- [ReScript](https://rescript-lang.org) 11 with `@rescript/react` (JSX v4)
- [Chakra UI](https://chakra-ui.com) 2 for layout/theme + Tailwind for utility classes
- [ApexCharts](https://apexcharts.com) (`react-apexcharts`) for all graphs
- [@preact/signals-react](https://preactjs.com/guide/v10/signals/) as the global store
- [`@greenlabs/ppx-spice`](https://github.com/green-labs/ppx_spice) for JSON decoding

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

## Production build

```sh
bun run build   # emits ./dist
```

Copy the contents of `dist/` into `Oxygen.jl/data/dashboard`. When serving the
dashboard, Oxygen rewrites every occurrence of
`/df9a0d86-3283-4920-82dc-4555fc0d1d8b/` to `<docs_path>/metrics/`, which is why:

- `vite.config.js` sets the production `base` to that path (asset URLs), and
- `src/Metrics.res` builds its API URL from the same path (`.../data`).

This is the exact mechanism the original dashboard used, so a custom `docs_path`
keeps working without any rebuild.

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
