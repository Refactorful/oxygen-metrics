@react.component
let make = (~children, ~size, ~borderRadius=12) => {
  let boxstyle: JsxDOM.style = {
    borderRadius: Int.toString(borderRadius) ++ "px",
    backgroundColor: "#2c5282",
    color: "white",
    height: Int.toString(size) ++ "px",
    width: Int.toString(size) ++ "px",
  }
  <div className="flex items-center justify-center" style={boxstyle}> {children} </div>
}
