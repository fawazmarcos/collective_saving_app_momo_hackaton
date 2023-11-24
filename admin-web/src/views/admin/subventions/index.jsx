// Chakra imports
import { Box, SimpleGrid } from '@chakra-ui/react';

import ComplexTable from 'views/admin/subventions/components/ComplexTable';
import { columnsDataComplex } from 'views/admin/subventions/variables/columnsData';

import React, { useEffect, useState, useMemo } from 'react';

import { database } from 'config/firebase-config';
import { getDocs, collection } from 'firebase/firestore';

export default function Subventions() {
  const [subscriptionsLists, setSubscriptionsLists] = useState([]);

  const subventionsCollectionRef = useMemo(
    () => collection(database, 'demandes_subvention'),
    []
  );

  const getAllSubventionsRequests = async () => {
    try {
      const response = await getDocs(subventionsCollectionRef);
      const filteredData = response.docs.map(doc => ({
        ...doc.data(),
      }));

      setSubscriptionsLists(filteredData);
    } catch (error) {
      console.log('error', error);
    }
  };

  useEffect(() => {
    getAllSubventionsRequests();
  }, [subventionsCollectionRef]);

  // Chakra Color Mode
  return (
    <Box pt={{ base: '130px', md: '80px', xl: '80px' }}>
      <SimpleGrid
        mb="20px"
        columns={{ sm: 1, md: 1 }}
        spacing={{ base: '20px', xl: '20px' }}
      >
        <ComplexTable
          getAllSubventionsRequests={getAllSubventionsRequests}
          columnsData={columnsDataComplex}
          tableData={subscriptionsLists}
        />
      </SimpleGrid>
    </Box>
  );
}
