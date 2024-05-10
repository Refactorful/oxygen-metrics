open Chakra
open ApexCharts

let logChecked = (e: ReactEvent.Form.t) => {
  let value: bool = ReactEvent.Form.target(e)["checked"]
  Js.log(value)
}

module MyChart = {
  let options = {
    "chart": {
      "id": "basic-bar",
    },
    "xaxis": {
      "categories": [1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999],
    },
  }

  let series = [
    {
      "name": "series-1",
      "data": [30, 40, 45, 50, 49, 60, 70, 91],
    },
  ]

  @react.component
  let make = () => {
    <BarChart series options width="600" height="300" />
  }
}

module MyPie = {
  let series = [44, 55, 41, 17, 15]

  @react.component
  let make = () => {
    <DonutChart series width="600" height="300" />
  }
}

module MuButton = {
  @react.component
  let make = (~children, ~onClick) => {
    <Button onClick={onClick}> children </Button>
  }
}

module TestPage = {
  @react.component
  let make = () => {
    let (count, setCount) = React.useState(() => 0)

    let (isOpen, setIsOpen) = React.useState(() => true)

    <div className="p-6" style={{backgroundColor: "red"}}>
      <Card>
        <CardBody>
          <Text> "Hello, World!" </Text>
          <MyChart />
          <MyPie />
        </CardBody>
      </Card>
      <Drawer isOpen={isOpen} onClose={() => setIsOpen(_ => false)}>
        <DrawerOverlay />
        <DrawerContent>
          <DrawerCloseButton />
          <DrawerHeader> {`3 drawer contents`->React.string} </DrawerHeader>
          <DrawerBody>
            <p> {"hello world"->React.string} </p>
          </DrawerBody>
        </DrawerContent>
      </Drawer>
      <MuButton onClick={_ => Js.log("i was clicked!")}>
        <Text> "my button" </Text>
      </MuButton>
      <Button onClick={_ => Js.log("hello world")}>
        <Text> "Click me!!!" </Text>
      </Button>
      <Checkbox onChange={e => logChecked(e)}>
        <p> {React.string("checked")} </p>
      </Checkbox>
      <h1 className="text-3xl font-semibold"> {"What is this about?"->React.string} </h1>
      <p>
        {React.string(
          "This is a simple template for a Vite project using ReScript & Tailwind CSS.",
        )}
      </p>
      <h2 className="text-2xl font-semibold mt-5"> {React.string("Fast Refresh Test")} </h2>
      <Button onClick={_ => setCount(count => count + 1)}>
        <Text> {`count is ${count->Int.toString}`} </Text>
      </Button>
      <p>
        {React.string("Edit ")}
        <code> {React.string("src/App.res")} </code>
        {React.string(" and save to testsdfds Fast Refresh")}
      </p>
    </div>
  }
}

Js.log("Loaded")
module SideBar = {

  @react.component
  let make = () => {
    <Box backgroundColor="lightblue">
      <Box className="p-4">
        <Text className="text-lg font-semibold">"My App"</Text>
      </Box>
      <Box className="flex-1 overflow-y-auto">
        <Box className="p-2">
          <Link onClick={_ => RescriptReactRouter.push("/data")}>
            <Text className="text-white"> "Data" </Text>
          </Link>
        </Box>
        <Box className="p-2">
          <Link onClick={_ => RescriptReactRouter.push("/test")}>
            <Text className="text-white"> "Test" </Text>
          </Link>
        </Box>
      </Box>
    </Box>
  }

}


module CurrentPage = {
  // App.res
  @react.component
  let make = () => {
    let url = RescriptReactRouter.useUrl()
    switch url.path {
    | list{} =>
      <Card>
        <CardBody>
          <Text> "Hello, World!" </Text>
        </CardBody>
      </Card>
    | list{"data"} => <MyChart />
    | list{"test"} => <TestPage />
    | list{"sidebar"} => <SideBar />
    | _ => <Text> "404" </Text>
    }
  }
}

@react.component
let make = () => {
  <CurrentPage />
}
