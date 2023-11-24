import {
  Flex,
  Table,
  Progress,
  Tbody,
  Td,
  Text,
  Th,
  Thead,
  Tr,
  useColorModeValue,
} from '@chakra-ui/react';
import React, { useMemo } from 'react';
import {
  useGlobalFilter,
  usePagination,
  useSortBy,
  useTable,
} from 'react-table';
import moment from 'moment';

// Custom components
import Card from 'components/card/Card';

// Assets
export default function ColumnsTable(props) {
  const { columnsData, tableData } = props;

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
          Souscriptions
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
                  } else if (cell.column.Header === 'EPARGNE') {
                    data = (
                      <Text color={textColor} fontSize="sm" fontWeight="700">
                        {cell.value}
                      </Text>
                    );
                  } else if (cell.column.Header === 'CAPITAL') {
                    data = (
                      <Text color={textColor} fontSize="sm" fontWeight="700">
                        {cell.value}
                      </Text>
                    );
                  } else if (cell.column.Header === 'STATUT') {
                    data = (
                      <Flex align="center">
                        <Text
                          color={
                            cell.value === 0
                              ? 'green.500'
                              : cell.value === 1
                              ? 'red.500'
                              : cell.value === 2
                              ? 'yellow.500'
                              : null
                          }
                          fontSize="sm"
                          fontWeight="700"
                        >
                          {cell.value === 0
                              ? 'Clôturé'
                              : cell.value === 1
                              ? 'En cours'
                              : cell.value === 2
                              ? 'Demande de retrait'
                              : ''}
                        </Text>
                      </Flex>
                    );
                  } else if (cell.column.Header === 'COMPTE EPARGNE') {
                    data = (
                      <Text color={textColor} fontSize="sm" fontWeight="700">
                        {cell.value ? 'Bloqué' : 'Non bloquée'}
                      </Text>
                    );
                  } else if (cell.column.Header === 'Date Retrait Prévu') {
                    data = (
                      <Text color={textColor} fontSize="sm" fontWeight="700">
                        {moment(cell.value.seconds).format('DD-MM-YYYY')}
                      </Text>
                    );
                  } else if (cell.column.Header === 'CRÉÉ LE') {
                    data = (
                      <Text color={textColor} fontSize="sm" fontWeight="700">
                        {cell.value}
                      </Text>
                    );
                  } else if (cell.column.Header === 'PROGRESSION') {
                    data = (
                      <Flex align="center">
                        <Progress
                          variant="table"
                          colorScheme="brandScheme"
                          h="8px"
                          w="108px"
                          value={50}
                        />
                      </Flex>
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
