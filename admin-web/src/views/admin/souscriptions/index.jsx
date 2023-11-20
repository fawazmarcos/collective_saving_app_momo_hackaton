// Chakra imports
import { Box, SimpleGrid } from '@chakra-ui/react';

import ComplexTable from 'views/admin/souscriptions/components/ComplexTable';
import { columnsDataComplex } from 'views/admin/souscriptions/variables/columnsData';

import React, { useEffect, useState, useMemo } from 'react';

import { database } from 'config/firebase-config';
import { getDocs, collection } from 'firebase/firestore';

export default function Subscription() {
  const [subscriptionsLists, setSubscriptionsLists] = useState([]);

  const subscriptionsCollectionRef = useMemo(
    () => collection(database, 'souscriptions'),
    []
  );

  useEffect(() => {
    const getAllTransactions = async () => {
      try {
        const response = await getDocs(subscriptionsCollectionRef);
        const filteredData = response.docs.map(doc => ({
          ...doc.data(),
        }));

        setSubscriptionsLists(filteredData);
      } catch (error) {
        console.log('error', error);
      }
    };
    getAllTransactions();
  }, [subscriptionsCollectionRef]);

  // Chakra Color Mode
  return (
    <Box pt={{ base: '130px', md: '80px', xl: '80px' }}>
      <SimpleGrid
        mb="20px"
        columns={{ sm: 1, md: 1 }}
        spacing={{ base: '20px', xl: '20px' }}
      >
        <ComplexTable
          columnsData={columnsDataComplex}
          tableData={subscriptionsLists}
        />
      </SimpleGrid>
    </Box>
  );
}
