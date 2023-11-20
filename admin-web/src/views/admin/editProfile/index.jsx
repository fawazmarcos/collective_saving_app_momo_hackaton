// Chakra imports
import { Box } from '@chakra-ui/react';
import UserProfileEdit from './components/editProfile';
import React from 'react';

export default function EditProfile() {
  // Chakra Color Mode
  return (
    <Box pt={{ base: '130px', md: '80px', xl: '80px' }}>
      <UserProfileEdit />
    </Box>
  );
}
