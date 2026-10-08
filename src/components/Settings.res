open Chakra

let intervalOptions = [
  ("1", "1 Second"),
  ("3", "3 Seconds"),
  ("5", "5 Seconds"),
  ("10", "10 Seconds"),
  ("30", "30 Seconds"),
  ("60", "60 Seconds"),
]

let intervalOption = ((value, label)) => <option key=value value> {React.string(label)} </option>

/**
  The "Oxygen Metrics Settings" drawer: a right-hand slide-in that mirrors the
  original Configurator, wired to the same global settings signals
 */
@react.component
let make = (~isOpen, ~onClose) => {
  Signals.useSignals()

  let poll = AppState.poll->Signals.val
  let interval = AppState.interval->Signals.val
  let expandedView = AppState.expandedView->Signals.val

  let {colorMode, toggleColorMode} = Chakra.useColorMode()

  <Drawer isOpen onClose placement="right" blockScrollOnMount={false}>
    <DrawerOverlay />
    <DrawerContent>
      <DrawerCloseButton />
      <DrawerHeader pt="24px" px="24px">
        <Text fontSize="xl" fontWeight="bold" mt="16px" mb="16px">
          "Oxygen Metrics Settings"
        </Text>
        <Separator />
      </DrawerHeader>
      <DrawerBody w="340px" ps="24px" pe="40px">
        <Flex direction="column">
          <Box display="flex" justifyContent="space-between" alignItems="center">
            <Text fontSize="md" fontWeight="600" mb="4px"> "Poll Server" </Text>
            <Switch
              isChecked=poll
              onChange={_ => AppState.poll->Signals.set(!(AppState.poll->Signals.val))}
            />
          </Box>

          <Box display="flex" justifyContent="space-between" alignItems="center" mt="3">
            <Text fontSize="md" fontWeight="600" mb="4px"> "Interval" </Text>
            <Select
              value={Int.toString(interval)}
              size="md"
              w="140px"
              onChange={event => {
                let value = ReactEvent.Form.target(event)["value"]->String.make
                switch Int.fromString(value) {
                | Some(interval) => AppState.interval->Signals.set(interval)
                | None => ()
                }
              }}>
              {intervalOptions->Array.map(intervalOption)->React.array}
            </Select>
          </Box>

          <Separator mt="5" mb="5" />

          <Box display="flex" justifyContent="space-between" alignItems="center">
            <Text fontSize="md" fontWeight="600" mb="4px"> "Expand Graphs" </Text>
            <Switch
              isChecked=expandedView
              onChange={_ => AppState.expandedView->Signals.set(!(AppState.expandedView->Signals.val))}
            />
          </Box>

          <Separator mt="5" mb="5" />

          <Flex justify="space-between" align="center" mb="24px">
            <Text fontSize="md" fontWeight="600" mb="4px"> "Dark/Light" </Text>
            <Button onClick={_ => toggleColorMode()}>
              {React.string(colorMode == "light" ? "Toggle Dark" : "Toggle Light")}
            </Button>
          </Flex>

          <Separator />
        </Flex>
      </DrawerBody>
    </DrawerContent>
  </Drawer>
}
