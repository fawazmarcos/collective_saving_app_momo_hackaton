import {
  Button,
  Flex,
  FormControl,
  FormLabel,
  Input,
  Modal,
  ModalBody,
  ModalCloseButton,
  ModalContent,
  ModalFooter,
  ModalHeader,
  ModalOverlay,
  Table,
  Tbody,
  Td,
  Text,
  Th,
  Thead,
  Tr,
  useColorModeValue,
  useToast,
  useDisclosure,
} from '@chakra-ui/react';
import React, { useMemo } from 'react';
import {
  useGlobalFilter,
  usePagination,
  useSortBy,
  useTable,
} from 'react-table';
// import moment from 'moment';
import { doc, updateDoc, getDoc } from 'firebase/firestore';
import { database } from 'config/firebase-config';

// Custom components
import Card from 'components/card/Card';

// Assets
export default function ColumnsTable(props) {
  const { getAllSubventionsRequests, columnsData, tableData } = props;
  const { isOpen, onOpen, onClose } = useDisclosure();

  const initialRef = React.useRef(null);
  const finalRef = React.useRef(null);
  const toast = useToast();
  const columns = useMemo(() => columnsData, [columnsData]);
  const data = useMemo(() => tableData, [tableData]);
  const [loading, setLoading] = React.useState(false);
  const [amount, setAmount] = React.useState(0);
  const [infos, setInfos] = React.useState({});

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

  // Update 'traitement' to '1 = Traitée' after validate request
  const updateRequest = async (id, status, amount) => {
    const requestDoc = doc(database, 'demandes_subvention', id);
    await updateDoc(requestDoc, {
      traitement: status,
      montant: amount,
    });
  };

  // Update 'montantpaye' after accept subvention request
  const updateAmountSaving = async (id, amount) => {
    const sousDocRef = doc(database, 'souscriptions', id);
    const sousDocSnapshot = await getDoc(sousDocRef);

    if (sousDocSnapshot.exists()) {
      let actualSolde =
        sousDocSnapshot?._document?.data?.value?.mapValue?.fields?.montantPaye
          ?.integerValue;

      const newAmount = parseInt(actualSolde) + parseInt(amount);
      const requestDoc = doc(database, 'souscriptions', id);
      await updateDoc(requestDoc, { montantPaye: parseInt(newAmount) });
    }
  };

  // Function to validate subvention request
  const submitSubventions = async () => {
    setLoading(true);

    try {
      await updateRequest(infos?.id, 1, amount);
      await updateAmountSaving(infos?.idSouscription, parseInt(amount));
      getAllSubventionsRequests();
      setLoading(false);
      onClose();
      toast({
        position: 'top-right',
        title: 'Subvention accordée!',
        description: 'Paiement effectué avec succès',
        status: 'success',
        duration: 5000,
        isClosable: true,
      });
    } catch (e) {
      console.log('e', e);
      setLoading(true);
    }
  };

  return (
    <Card
      direction="column"
      w="100%"
      px="0px"
      overflowX={{ sm: 'scroll', lg: 'hidden' }}
    >
      <Flex px="25px" justify="space-between" mb="20px" align="center">
        <Text
          color={textColor}
          fontSize="22px"
          fontWeight="700"
          lineHeight="100%"
        >
          Demande de Subventions
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
                        {cell.value === null ? 0 : cell.value}
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
                      <>
                        <Button
                          color={'white'}
                          colorScheme="blue"
                          size="md"
                          w={'100%'}
                          px={'2rem'}
                          onClick={() => {
                            onOpen();
                            setInfos(cell?.row?.original);
                          }}
                          disabled={
                            cell?.row?.original?.traitement === 1 ? true : false
                          }
                        >
                          Valider
                        </Button>
                        <Modal
                          initialFocusRef={initialRef}
                          finalFocusRef={finalRef}
                          isOpen={isOpen}
                          onClose={onClose}
                        >
                          <ModalOverlay />
                          <ModalContent>
                            <ModalHeader>Accorder la subvention</ModalHeader>
                            <ModalCloseButton />
                            <ModalBody pb={6}>
                              <FormControl>
                                <FormLabel>Montant</FormLabel>
                                <Input
                                  type="number"
                                  onChange={e => setAmount(e.target.value)}
                                  ref={initialRef}
                                  placeholder="Entrer un montant"
                                />
                              </FormControl>
                            </ModalBody>

                            <ModalFooter>
                              <Button
                                isLoading={loading}
                                colorScheme="blue"
                                variant="solid"
                                mr={3}
                                onClick={() => submitSubventions()}
                              >
                                Ajouter
                              </Button>
                              <Button onClick={onClose}>Annuler</Button>
                            </ModalFooter>
                          </ModalContent>
                        </Modal>
                      </>
                    );
                  }

                  return (
                    <Td
                      {...cell.getCellProps()}
                      key={index}
                      fontSize={{ sm: '14px' }}
                      minW={{ sm: '150px', md: '200px', lg: 'auto' }}
                      borderColor="transparent"
                      textAlign={'center'}
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
