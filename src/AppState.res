open Signals

type theme = 
| Light
| Dark

let settings = {
    "isOpen": signal(false),
    "pollInterval": signal(5),
    "pollServer": signal(true),
    "expandGraphs": signal(true),
    "theme": signal(Light),
}
