// Chakra imports
import { Box, SimpleGrid } from '@chakra-ui/react';

import ComplexTable from 'views/admin/dataTables/components/ComplexTable';
import { columnsDataComplex } from 'views/admin/dataTables/variables/columnsData';

import tableDataComplex from 'views/admin/dataTables/variables/tableDataComplex.json';
import React, { useEffect, useState, useMemo } from 'react';

import { database } from 'config/firebase-config';
import { getDocs, collection } from 'firebase/firestore';

export default function Settings() {
  const [transactionsLists, setTransactionsLists] = useState([]);

  const transactionsCollectionRef = useMemo(
    () => collection(database, 'transactions'),
    []
  );

  useEffect(() => {
    const getAllTransactions = async () => {
      try {
        const response = await getDocs(transactionsCollectionRef);
        const filteredData = response.docs.map(doc => ({
          ...doc.data(),
        }));
        console.log('filteredData transac', filteredData);
        setTransactionsLists(filteredData);
      } catch (error) {
        console.log('error', error);
      }
    };
    getAllTransactions();
  }, [transactionsCollectionRef]);

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
          tableData={transactionsLists}
        />
      </SimpleGrid>
    </Box>
  );
}
