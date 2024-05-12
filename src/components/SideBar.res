open Chakra
open ReactIcons

module SideBar = {
  
  @react.component
  let make = (~routes) => {
    let (selectedIndex, setSeletedIndex) = React.useState(() => 0)
    let (isOpen, setIsOpen) = React.useState(() => true)

    <VStack
      className={`text-center h-full transition-width duration-300 ease-in-out`}
      style={{width: isOpen ? "200px" : "80px"}}>
      <Box className="w-full">
        <Text className="text-lg font-semibold"> "Oxygen Metrics" </Text>
      </Box>
      <Box className="flex-1 w-full overflow-y-auto">
        {routes
        ->Belt.Array.mapWithIndex((index, route) => {
          let bgcolor = selectedIndex == index ? "bg-gray-100" : "white"
          let centered = isOpen ? "" : "flex items-center justify-center"      
            <Box
              className={`${centered} ${bgcolor} w-full p-2 cursor-pointer hover:bg-gray-200`}
              key={Int.toString(index)}
              onClick={_ => {
                RescriptReactRouter.push(route["path"])
                setSeletedIndex(_ => index)
              }}>
              <HStack>
                // Always show icons
                {route["icon"]}
                {
                  if isOpen {
                    <Text> {route["name"]} </Text>
                  } else {
                    <> </>
                  }
                }
              </HStack>
            </Box>
        })
        ->React.array}
      </Box>
      <Box className="w-full">
        <Button className="w-full float-right" onClick={_ => setIsOpen(p => !p)}>
          {isOpen ? <TbLayoutSidebarRightExpand /> : <TbLayoutSidebarLeftExpand />}
        </Button>
      </Box>
    </VStack>
  }
}