open Chakra
open IconBox

// Create global binding for toLocaleString
@send external toLocaleString: float => string = "toLocaleString"

@react.component
let make = (~title, ~value, ~icon, ~prefix=?, ~postfix=?) => {
  <div className="p-2 shadow-sm rounded-xl bg-white">
    <HStack className="flex justify-between">
      <Box className="m-0 p-3">
        <Stat>
          <StatLabel> {title} </StatLabel>
          <StatNumber>
            { Option.getOr(prefix, "") ++ toLocaleString(value) ++ Option.getOr(postfix, "") }
          </StatNumber>
        </Stat>
      </Box>
      <Box className="m-3">
        <IconBox size=45> {icon} </IconBox>
      </Box>
    </HStack>
  </div>
}
