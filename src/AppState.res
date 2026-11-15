open Signals

type theme = Light | Dark

// ---------------------------------------------------------------------------
// Dashboard controls
// ---------------------------------------------------------------------------

// Number of minutes to look back on first load, or "null" for the full history
let windowValue = signal("15")

// When true, missing timestamps are filled with zeros up to the current time
let fillGaps = signal(true)

// ---------------------------------------------------------------------------
// Polling settings
// ---------------------------------------------------------------------------

// Pause/resume the incremental polling loop
let poll = signal(true)

// Delay between polls, in seconds
let interval = signal(3)

// ---------------------------------------------------------------------------
// UI settings
// ---------------------------------------------------------------------------

// Expand charts to full-width rows (vs. a two column grid)
let expandedView = signal(false)

// Chakra color mode, mirrored here so charts can react to it
let theme = signal(Light)
