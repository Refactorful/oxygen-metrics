type t<'value>

@set external set: (t<'value>, 'value) => unit = "value"
@get external val: t<'value> => 'value = "value"

@module("@preact/signals-react")
external signal: 'value => t<'value> = "signal"

@module("@preact/signals-react")
external useSignal: 'value => t<'value> = "useSignal"

@module("@preact/signals-react")
external useComputed: (unit => 'value) => t<'value> = "useComputed"

@module("@preact/signals-core")
external computed: (unit => 'value) => t<'value> = "computed"

@module("@preact/signals-core")
external effect: (unit => unit) => unit = "effect"

@module("@preact/signals-core")
external effectWithCleanup: (unit => unit) => unit => unit = "effect"

@module("@preact/signals-core")
external batch: (unit => unit) => unit = "batch"

// Used inside a component that's that uses signals
@module("@preact/signals-react/runtime")
external useSignals: unit => unit = "useSignals"

// type effectStoreUsage =
//   | UNMANAGED
//   | MANAGED_COMPONENT
//   | MANAGED_HOOK

// let toInt = (usage: effectStoreUsage) =>
//   switch usage {
//   | UNMANAGED => 0
//   | MANAGED_COMPONENT => 1
//   | MANAGED_HOOK => 2
//   }

// @module("@preact/signals-react/runtime")
// external useSignalsRaw: effectStoreUsage => unit = "useSignals"
// let useSignals = (~storage=UNMANAGED) => useSignalsRaw(storage)
