
open Chakra
open ReactIcons
open IconBox

// Components
open SideBar
// open Settings

// module LazyDashboard = {
//   let make = React.lazy_(() => Js.import(Dashboard.make))
// }


module Router = {
  @react.component
  let make = () => {
    let url = RescriptReactRouter.useUrl()
    switch url.path {
    | list{} => <Dashboard />
    // | list{"data"} => <MyChart />
    | _ => <Text> "404" </Text>
    }
  }
}

let routes = [
  {
    "path": "/",
    "name": "Dashboard",
    "icon": <IconBox size=30 borderRadius=8> <IoHome size=15/> </IconBox>,
  },
  {
    "path": "/data",
    "name": "Test",
    "icon": <IconBox size=30 borderRadius=8> <TbGraph size=15/> </IconBox>,
  },
]

@react.component
let make = () => {
  <HStack style={{height: "100vh", backgroundColor: "#F7FAFC"}}>
    <Box className="h-full">
      <SideBar routes />
    </Box>
    <Box className="h-full w-full overflow-y-auto">
      <Settings />
      <Router />
    </Box>
  </HStack>
}
