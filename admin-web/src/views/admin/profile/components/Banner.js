// Chakra imports
import {
  Avatar,
  Box,
  HStack,
  Link,
  Tag,
  TagLabel,
  TagRightIcon,
  Text,
  useColorModeValue,
} from '@chakra-ui/react';
import Card from 'components/card/Card.js';
import React from 'react';
import { FaUserEdit } from 'react-icons/fa';

export default function Banner(props) {
  const { banner, avatar, name, email } = props;
  // Chakra Color Mode
  const textColorPrimary = useColorModeValue('secondaryGray.900', 'white');
  const textColorSecondary = 'gray.400';
  const borderColor = useColorModeValue(
    'white !important',
    '#111C44 !important'
  );
  return (
    <Card mb={{ base: '0px', lg: '20px' }} align="center">
      <Box
        bg={`url(${banner})`}
        bgSize="cover"
        borderRadius="16px"
        h="131px"
        w="100%"
      />
      <Avatar
        mx="auto"
        src={avatar}
        h="87px"
        w="87px"
        mt="-43px"
        border="4px solid"
        borderColor={borderColor}
      />

      <HStack justifyContent={'center'} mt={2}>
        <Link href={'/profile/edit-profile'}>
          <Tag size={'lg'} variant="outline" colorScheme="blue">
            <TagLabel>Modifier son profil</TagLabel>
            <TagRightIcon as={FaUserEdit} />
          </Tag>
        </Link>
      </HStack>

      <Text color={textColorPrimary} fontWeight="bold" fontSize="xl" mt="10px">
        {name}
      </Text>
      <Text color={textColorSecondary} fontSize="sm">
        {email}
      </Text>
    </Card>
  );
}
