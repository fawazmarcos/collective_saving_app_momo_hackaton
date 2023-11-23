import { Box, SimpleGrid } from '@chakra-ui/react';

import ComplexTable from 'views/admin/typeEpargnes/components/ComplexTable';
import { columnsDataComplex } from 'views/admin/typeEpargnes/variables/columnsData';

import React, { useEffect, useState, useMemo } from 'react';

import { database } from 'config/firebase-config';
import { getDocs, collection } from 'firebase/firestore';
import ModalSavings from './components/Modal';

export default function TypeofSaving() {
  const [subscriptionsLists, setSubscriptionsLists] = useState([]);

  const typeofsavingsCollectionRef = useMemo(
    () => collection(database, 'types_epargne'),
    []
  );

  const getAllTransactions = async () => {
    try {
      const response = await getDocs(typeofsavingsCollectionRef);
      const filteredData = response.docs.map(doc => ({
        ...doc.data(),
        id: doc.id,
      }));

      setSubscriptionsLists(filteredData);
    } catch (error) {
      console.log('error', error);
    }
  };

  useEffect(() => {
    getAllTransactions();
  }, [typeofsavingsCollectionRef]);

  return (
    <Box pt={{ base: '130px', md: '80px', xl: '80px' }}>
      <Box mb={'16px'}>
        <ModalSavings getAllTransactions={getAllTransactions} />
      </Box>

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
