import {
  Button,
  Flex,
  Table,
  Tbody,
  Td,
  Text,
  Th,
  Thead,
  Tr,
  useColorModeValue,
  useToast,
} from '@chakra-ui/react';
import React, { useMemo } from 'react';
import {
  useGlobalFilter,
  usePagination,
  useSortBy,
  useTable,
} from 'react-table';
// import moment from 'moment';
import axios from 'axios';
import { doc, updateDoc, collection, addDoc, getDoc } from 'firebase/firestore';
import { database } from 'config/firebase-config';
import moment from 'moment';

// Custom components
import Card from 'components/card/Card';

// Assets
export default function ColumnsTable(props) {
  const { getAllWithdrawlsRequests, columnsData, tableData } = props;

  const toast = useToast();
  const columns = useMemo(() => columnsData, [columnsData]);
  const data = useMemo(() => tableData, [tableData]);

  const tableInstance = useTable(
    {
      columns,
      data,
    },
    useGlobalFilter,
    useSortBy,
    usePagination
  );

  const {
    getTableProps,
    getTableBodyProps,
    headerGroups,
    page,
    prepareRow,
    initialState,
  } = tableInstance;
  initialState.pageSize = 5;

  const textColor = useColorModeValue('secondaryGray.900', 'white');
  const borderColor = useColorModeValue('gray.200', 'whiteAlpha.100');

  // Update 'traitement' to '1 = Traitée' after withdrawl request
  const updateRequest = async (id, status) => {
    const requestDoc = doc(database, 'demandes_retrait', id);
    await updateDoc(requestDoc, { traitement: status });
  };

  // Update 'montantpaye' after withdrawl request
  const updateAmountSaving = async (id, amount) => {
    const sousDocRef = doc(database, 'souscriptions', id);
    const sousDocSnapshot = await getDoc(sousDocRef);

    if (sousDocSnapshot.exists()) {
      let actualSolde =
        sousDocSnapshot?._document?.data?.value?.mapValue?.fields?.montantPaye
          ?.integerValue;

      const newAmount = actualSolde - amount;
      const requestDoc = doc(database, 'souscriptions', id);
      await updateDoc(requestDoc, { montantPaye: parseInt(newAmount) });
    }
  };

  const transactionsCollectionRef = React.useMemo(
    () => collection(database, 'transactions'),
    []
  );

  // Intialize withdrawl transaction in trasactions table in process to validate withdrawl request
  const createTransaction = async data => {
    try {
      await addDoc(transactionsCollectionRef, {
        createdAt: moment(Date.now()).format('DD-MM-YYYY'),
        typeTransaction: 'Retrait',
        idUtilisateur: data.telephone,
        montant: data.montant,
        idSouscription: data.idSouscription,
        telephone: data.telephone,
      });
    } catch (e) {
      console.log('errrr in create', e);
    }
  };
  // Function to validate withdrawals request
  const submitWithdrawls = async data => {
    try {
      const formData = new FormData();
      formData.append('telephone', data.telephone);
      formData.append('montant', data.montant);

      const res = await axios.post(
        'https://dev.macotech.tech/momo_api/disbursement/deposit.php',
        formData
      );
      if (res?.status === 200) {
        await updateRequest(data?.id, 1);
        await updateAmountSaving(data?.idSouscription, data.montant);
        await createTransaction(data);
        getAllWithdrawlsRequests();

        toast({
          position: 'top-right',
          title: 'Transaction effectuée!',
          description: 'Paiement effectué avec succès',
          status: 'success',
          duration: 5000,
          isClosable: true,
        });
      } else if (res?.status === 400) {
        toast({
          position: 'top-right',
          title: 'Erreur!',
          description: 'Une erreur s’est produite',
          status: 'error',
          duration: 5000,
          isClosable: true,
        });
      }
    } catch (e) {
      console.log('e', e);
    }
  };

  return (
    <Card
      direction="column"
      w="100%"
      px="0px"
      overflowX={{ sm: 'scroll', lg: 'scroll' }}
    >
      <Flex px="25px" justify="space-between" mb="20px" align="center">
        <Text
          color={textColor}
          fontSize="22px"
          fontWeight="700"
          lineHeight="100%"
        >
          Demande de Retraits
        </Text>
      </Flex>
      <Table {...getTableProps()} variant="simple" color="gray.500" mb="24px">
        <Thead>
          {headerGroups.map((headerGroup, index) => (
            <Tr {...headerGroup.getHeaderGroupProps()} key={index}>
              {headerGroup.headers.map((column, index) => (
                <Th
                  {...column.getHeaderProps(column.getSortByToggleProps())}
                  pe="10px"
                  key={index}
                  borderColor={borderColor}
                >
                  <Flex
                    justify="space-between"
                    align="center"
                    fontSize={{ sm: '10px', lg: '12px' }}
                    color="gray.400"
                  >
                    {column.render('Header')}
                  </Flex>
                </Th>
              ))}
            </Tr>
          ))}
        </Thead>
        <Tbody {...getTableBodyProps()}>
          {page.map((row, index) => {
            prepareRow(row);
            return (
              <Tr {...row.getRowProps()} key={index}>
                {row.cells.map((cell, index) => {
                  let data = '';
                  if (cell.column.Header === 'ID') {
                    data = (
                      <Text color={textColor} fontSize="sm" fontWeight="700">
                        {cell.value}
                      </Text>
                    );
                  } else if (cell.column.Header === 'ID SOUSCRIPTION') {
                    data = (
                      <Text color={textColor} fontSize="sm" fontWeight="700">
                        {cell.value}
                      </Text>
                    );
                  } else if (cell.column.Header === 'MONTANT') {
                    data = (
                      <Text color={textColor} fontSize="sm" fontWeight="700">
                        {cell.value}
                      </Text>
                    );
                  } else if (cell.column.Header === 'TELEPHONE') {
                    data = (
                      <Text color={textColor} fontSize="sm" fontWeight="700">
                        {cell.value}
                      </Text>
                    );
                  } else if (cell.column.Header === 'TRAITEMENT') {
                    data = (
                      <Flex align="center">
                        <Text
                          color={
                            cell.value === 0
                              ? 'red.500'
                              : cell.value === 1
                              ? 'green.500'
                              : ''
                          }
                          fontSize="sm"
                          fontWeight="700"
                        >
                          {cell.value === 0
                            ? 'Non traitée'
                            : cell.value === 1
                            ? 'Traitée'
                            : ''}
                        </Text>
                      </Flex>
                    );
                  } else if (cell.column.Header === 'CRÉÉ LE') {
                    data = (
                      <Text color={textColor} fontSize="sm" fontWeight="700">
                        {cell.value}
                      </Text>
                    );
                  } else if (cell.column.Header === 'ACTION') {
                    data = (
                      <Button
                        color={'white'}
                        colorScheme="blue"
                        size="md"
                        w={'100%'}
                        px={'2rem'}
                        onClick={() => submitWithdrawls(cell?.row?.original)}
                        disabled={
                          cell?.row?.original?.traitement === 1 ? true : false
                        }
                      >
                        Valider
                      </Button>
                    );
                  }

                  return (
                    <Td
                      {...cell.getCellProps()}
                      key={index}
                      fontSize={{ sm: '14px' }}
                      minW={{ sm: '150px', md: '200px', lg: 'auto' }}
                      borderColor="transparent"
                    >
                      {data}
                    </Td>
                  );
                })}
              </Tr>
            );
          })}
        </Tbody>
      </Table>
    </Card>
  );
}
