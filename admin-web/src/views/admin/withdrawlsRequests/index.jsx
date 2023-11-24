// Chakra imports
import { Box, SimpleGrid } from '@chakra-ui/react';

import ComplexTable from 'views/admin/withdrawlsRequests/components/ComplexTable';
import { columnsDataComplex } from 'views/admin/withdrawlsRequests/variables/columnsData';

import React, { useEffect, useState, useMemo } from 'react';

import { database } from 'config/firebase-config';
import { getDocs, collection } from 'firebase/firestore';

export default function WithdrawlsRequets() {
  const [subscriptionsLists, setSubscriptionsLists] = useState([]);

  const withdrawlsCollectionRef = useMemo(
    () => collection(database, 'demandes_retrait'),
    []
  );

  const getAllWithdrawlsRequests = async () => {
    try {
      const response = await getDocs(withdrawlsCollectionRef);
      const filteredData = response.docs.map(doc => ({
        ...doc.data(),
      }));

      setSubscriptionsLists(filteredData);
    } catch (error) {
      console.log('error', error);
    }
  };

  useEffect(() => {
    getAllWithdrawlsRequests();
  }, [withdrawlsCollectionRef]);

  // Chakra Color Mode
  return (
    <Box pt={{ base: '130px', md: '80px', xl: '80px' }}>
      <SimpleGrid
        mb="20px"
        columns={{ sm: 1, md: 1 }}
        spacing={{ base: '20px', xl: '20px' }}
      >
        <ComplexTable
          getAllWithdrawlsRequests={getAllWithdrawlsRequests}
          columnsData={columnsDataComplex}
          tableData={subscriptionsLists}
        />
      </SimpleGrid>
    </Box>
  );
}
