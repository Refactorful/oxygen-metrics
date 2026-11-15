open Chakra
open ApexCharts
open ReactIcons
open Metrics
open Util

module ChartContainer = {
  @react.component
  let make = (~title, ~children) => {
    let cardBg = Chakra.useColorModeValue("white", "gray.700")
    let textColor = Chakra.useColorModeValue("gray.700", "white")

    <Card
      p="28px 10px 16px 0px"
      bg=cardBg
      borderRadius="15px"
      shadow="0px 3.5px 5.5px rgba(0, 0, 0, 0.02)">
      <CardHeader p="0" pl="22px">
        <Text fontSize="lg" fontWeight="bold" mb="6px" color=textColor> {title} </Text>
      </CardHeader>
      <CardBody p="0"> {children} </CardBody>
    </Card>
  }
}

let windowOptions = [
  ("1", "1 minute"),
  ("5", "5 minute"),
  ("10", "10 minute"),
  ("15", "15 minutes"),
  ("30", "30 minutes"),
  ("60", "1 hour"),
  ("360", "6 hours"),
  ("720", "12 hours"),
  ("1440", "24 hours"),
  ("null", "All"),
]

let windowOption = ((value, label)) => <option key=value value> {React.string(label)} </option>

@react.component
let make = () => {
  Signals.useSignals()

  let server = Metrics.server->Signals.val
  let endpoints = Metrics.endpoints->Signals.val
  let errors = Metrics.errors->Signals.val
  let requestsPerSecond = Metrics.requestsPerSecond->Signals.val
  let avgLatencyPerSecond = Metrics.avgLatencyPerSecond->Signals.val
  let requestsPerMinute = Metrics.requestsPerMinute->Signals.val
  let avgLatencyPerMinute = Metrics.avgLatencyPerMinute->Signals.val
  let error = Metrics.error->Signals.val

  let fillGaps = AppState.fillGaps->Signals.val
  let windowValue = AppState.windowValue->Signals.val
  let expandedView = AppState.expandedView->Signals.val

  let legendColors = Chakra.useColorModeValue("black", "white")

  let chartRange = switch windowValue {
  | "null" => None
  | value => value->Int.fromString->Option.map(minutes => minutes * 60 * 1000)
  }

  let totalRequests = endpoints->flattenEntries(endpoint => endpoint.total_requests)
  let totalErrors = errors->flattenEntries(count => count)

  let requestsPerSecondData = fillGaps
    ? fillMissingData(~data=requestsPerSecond, ~unit=1000.)
    : requestsPerSecond
  let avgLatencyPerSecondData = fillGaps
    ? fillMissingData(~data=avgLatencyPerSecond, ~unit=1000.)
    : avgLatencyPerSecond
  let requestsPerMinuteData = fillGaps
    ? fillMissingData(~data=requestsPerMinute, ~unit=60_000.)
    : requestsPerMinute
  let avgLatencyPerMinuteData = fillGaps
    ? fillMissingData(~data=avgLatencyPerMinute, ~unit=60_000.)
    : avgLatencyPerMinute

  let gridColumns = expandedView
    ? {"sm": "1fr"}
    : merge({"sm": "1fr"}, {"lg": "1.5fr 1.5fr"})
  let gridRows = expandedView
    ? {"sm": "auto"}
    : merge({"sm": "repeat(2, 1fr)"}, {"lg": "1fr"})

  let hasData = server.total_requests > 0 || requestsPerSecond->Array.length > 0

  // Mount the charts immediately (like the original dashboard) so the Apex
  // creation cost happens before data arrives; the first response then only
  // updates the existing charts instead of mounting all of them at once
  <Box pt="30px" pb="30px" px="30px">
    {if !hasData && error->Option.isSome {
      <Text color="gray.400" fontSize="sm" mb="3">
        {"Waiting for the metrics server…" ++ error->Option.getOr("")}
      </Text>
    } else {
      React.null
    }}
    <Heading size="md" mb="5"> {"Server Metrics"} </Heading>

      <SimpleGrid columns={{"sm": 1, "md": 2, "xl": 3}} spacing="24px">
        <StatContainer
          title="Total Requests"
          value={server.total_requests->Float.fromInt->Float.toLocaleString}
          icon={<CiGlobe size=24 />}
        />
        <StatContainer
          title="Error Rate"
          value={(server.error_rate *. 100.)->Float.toFixed(~digits=2) ++ "%"}
          icon={<IoWarningOutline size=24 />}
        />
        <StatContainer
          title="Avg Latency"
          value={server.avg_latency->Float.toFixed(~digits=2) ++ " ms"}
          icon={<IoTimerOutline size=24 />}
        />
        <StatContainer
          title="95th Percentile Latency"
          value={server.percentile_latency_95th->Float.toFixed(~digits=2) ++ " ms"}
          icon={<IoMdPodium size=24 />}
        />
        <StatContainer
          title="Min Latency"
          value={server.min_latency->Float.toFixed(~digits=2) ++ " ms"}
          icon={<RiArrowDownDoubleLine size=24 />}
        />
        <StatContainer
          title="Max Latency"
          value={server.max_latency->Float.toFixed(~digits=2) ++ " ms"}
          icon={<RiArrowUpDoubleLine size=24 />}
        />
      </SimpleGrid>

      <Grid templateColumns=gridColumns templateRows=gridRows gap="24px" my="30px" mb="26px">
        <ChartContainer title="Requests Distribution">
          <Box style={{"height": "300px"}} ps="8px">
            <DonutChart
              width="100%"
              height="100%"
              series={totalRequests["values"]}
              options={{
                "labels": totalRequests["keys"],
                "stroke": {"show": true, "width": 1},
                "legend": {
                  "position": expandedView ? "right" : "bottom",
                  "labels": {"colors": legendColors},
                },
              }}
            />
          </Box>
        </ChartContainer>
        <ChartContainer title="Errors Distribution">
          <Box style={{"height": "300px"}} ps="8px">
            <DonutChart
              width="100%"
              height="100%"
              series={totalErrors["values"]}
              options={{
                "labels": totalErrors["keys"],
                "stroke": {"show": true, "width": 1},
                "legend": {
                  "position": expandedView ? "right" : "bottom",
                  "labels": {"colors": legendColors},
                },
              }}
            />
          </Box>
        </ChartContainer>
      </Grid>

      <Box display="flex" justifyContent="space-between" alignItems="center" height="60px">
        <Heading size="md"> {"Performance Insights"} </Heading>
        <Box display="flex" justifyContent="space-between" gap="15px">
          <Checkbox
            isChecked=fillGaps
            onChange={_ => AppState.fillGaps->Signals.set(!(AppState.fillGaps->Signals.val))}>
            {React.string("Fill Gaps")}
          </Checkbox>
          <Select
            value=windowValue
            size="md"
            w="140px"
            onChange={event => {
              let value = ReactEvent.Form.target(event)["value"]->String.make
              AppState.windowValue->Signals.set(value)
            }}>
            {windowOptions->Array.map(windowOption)->React.array}
          </Select>
        </Box>
      </Box>

      <Grid templateColumns=gridColumns templateRows=gridRows gap="24px" mb="26px">
        <ChartContainer title="Requests / Second">
          <BrushChart
            label="requests-per-second"
            range=?chartRange
            data=requestsPerSecondData
            height="268px"
          />
        </ChartContainer>
        <ChartContainer title="Avg Latency / Second">
          <BrushChart
            label="avg-latency-per-second"
            unit=" ms"
            range=?chartRange
            data=avgLatencyPerSecondData
            height="268px"
          />
        </ChartContainer>
        <ChartContainer title="Requests / Minute">
          <LineChart range=?chartRange data=requestsPerMinuteData />
        </ChartContainer>
        <ChartContainer title="Avg Latency / Minute">
          <LineChart unit=" ms" range=?chartRange data=avgLatencyPerMinuteData />
        </ChartContainer>
      </Grid>
    </Box>
}
