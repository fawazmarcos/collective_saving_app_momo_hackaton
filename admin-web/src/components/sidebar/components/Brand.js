import React from "react";

// Chakra imports
import { Flex, Heading } from "@chakra-ui/react";

// Custom components
// import { HorizonLogo } from "components/icons/Icons";
import { HSeparator } from "components/separator/Separator";

export function SidebarBrand() {
  //   Chakra color mode
  // let logoColor = useColorModeValue("navy.700", "white");

  return (
    <Flex align='center' direction='column'>
      {/* <HorizonLogo h='26px' w='175px' my='32px' color={logoColor} /> */}
      <Heading size="lg" my='30px' h='26px'>Collective Saving</Heading>
      <HSeparator mb='20px' />
    </Flex>
  );
}

export default SidebarBrand;
