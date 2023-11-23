// Chakra imports
import { Box, SimpleGrid } from '@chakra-ui/react';
import ComplexTable from 'views/admin/users/components/ComplexTable';
import { columnsDataComplex } from 'views/admin/users/variables/columnsData';

import React from 'react';
import { useEffect, useState, useMemo } from 'react';

import { database } from 'config/firebase-config';
import { getDocs, collection } from 'firebase/firestore';

export default function Users() {
  // Chakra Color Mode
  const [usersLists, setUsersLists] = useState([]);

  const usersCollectionRef = useMemo(() => collection(database, 'users'), []);

  useEffect(() => {
    const getUsersLists = async () => {
      try {
        const response = await getDocs(usersCollectionRef);
        const filteredData = response.docs.map(doc => ({
          ...doc.data()
        }));
        
        setUsersLists(filteredData);
      } catch (error) {
        console.log('error', error);
      }
    };
    getUsersLists();
  }, [usersCollectionRef]);

  return (
    <Box pt={{ base: '130px', md: '80px', xl: '80px' }}>
      <SimpleGrid
        mb="20px"
        columns={{ sm: 1, md: 1 }}
        spacing={{ base: '20px', xl: '20px' }}
      >
        <ComplexTable
          columnsData={columnsDataComplex}
          tableData={usersLists}
        />
      </SimpleGrid>
    </Box>
  );
}
