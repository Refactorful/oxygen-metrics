open Chakra
open IconBox

// Create global binding for toLocaleString
@send external toLocaleString: float => string = "toLocaleString"

// module IconBox = {

//   let boxstyle: JsxDOM.style = {
//     borderRadius: "12px",
//     backgroundColor: "#2c5282",
//     color: "white",
//     height: "45px",
//     width: "45px",
//   }

//   @react.component
//   let make = (~children) => {
//     <div className="flex items-center justify-center rounded-lg" style={boxstyle}>
//     {children}
//     </div>
//   }
// }

@react.component
let make = (~title, ~value, ~icon) => {
  <div className="p-2 shadow rounded-xl bg-white">
    <HStack className="flex justify-between">
      <Box className="m-3">
        <Stat>
          <StatLabel> {title} </StatLabel>
          <StatNumber> {toLocaleString(value)} </StatNumber>
        </Stat>
      </Box>
      <Box className="m-3">
        <IconBox size=45> {icon} </IconBox>
      </Box>
    </HStack>
  </div>
}
