open Chakra
open ApexCharts
open ReactIcons
open Signals
// open Store

// let logChecked = (e: ReactEvent.Form.t) => {
//   let value: bool = ReactEvent.Form.target(e)["checked"]
//   Js.log(value)
// }

module MyChart = {
  
  let options = {
    "chart": {
      "id": "basic-bar"
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
    <BarChart series options width="100%" height="300"/>
  }
}

module MyPie = {
  let series = [44, 55, 41, 17, 15]

  @react.component
  let make = () => {
    <DonutChart series width="100%" height="300" />
  }
}


module QueryDemo  = {

  @react.component
  let make = async () => {

 

    let response = await Fetch.get("https://api.github.com/repos/TanStack/query") 
    let data = await response->Fetch.Response.json
    Js.log(data)

    <Text> "hi" </Text>

  }
}

@react.component
let make = () => {
  useSignals()

  <div className="p-6">

  <Load></Load>
    // <Box>
    //   <Text>{getCount()->val -> Int.toString}</Text>
    //   <Button onClick={_ => getCount()->set(getCount()->val + 1)}><Text>"Increment"</Text></Button>
    // </Box>
    <Box>  
      <SimpleGrid columns={{"sm": 1, "md": 2, "xl": 3}} spacing="24px">
        <StatContainer title="Total Requests" value=52343. icon={<CiGlobe size=24 />} />
        <StatContainer title="Error Rate" value=52343. icon={<IoWarningOutline size=24 />} />
        <StatContainer title="Avg Latency" value=52343. icon={<IoTimerOutline size=24 />} />
        <StatContainer title="95th Percentile Latency" value=52343. icon={<IoMdPodium size=24 />} />
        <StatContainer title="Min Latency" value=52343. icon={<RiArrowDownDoubleLine size=24 />} />
        <StatContainer title="Max Latency" value=52343. icon={<RiArrowUpDoubleLine size=24 />} />
      </SimpleGrid>
    </Box>
    <br />
    <Box>
      <SimpleGrid columns={{"md": 1, "xl": 2}} spacing="24px">
        <Card>
          <CardBody>
            <MyPie />
          </CardBody>
        </Card>
        <Card>
          <CardBody>
            <MyChart />
          </CardBody>
        </Card>
          <Card>
          <CardBody>
            <MyChart />
          </CardBody>
        </Card>
          <Card>
          <CardBody>
            <MyPie />
          </CardBody>
        </Card>
          <Card>
          <CardBody>
            <MyPie />
          </CardBody>
        </Card>
          <Card>
          <CardBody>
            <MyChart />
          </CardBody>
        </Card>
      </SimpleGrid>
    </Box>
  </div>
}
