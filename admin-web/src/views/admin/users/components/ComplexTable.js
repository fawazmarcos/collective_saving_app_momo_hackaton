import {
  Flex,
  Table,
  Tbody,
  Td,
  Text,
  Th,
  Thead,
  Tr,
  useColorModeValue,
  Avatar,
  Tag,
  TagLabel,
  TagLeftIcon,
  Button,
} from '@chakra-ui/react';
import React, { useMemo } from 'react';
import {
  useGlobalFilter,
  usePagination,
  useSortBy,
  useTable,
} from 'react-table';

// Custom components
import Card from 'components/card/Card';

// Assets
import { BsDot } from 'react-icons/bs';

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
      <Flex px="25px" justify="flex-start" mb="20px" align="center">
        <Text
          color={textColor}
          fontSize="22px"
          fontWeight="700"
          lineHeight="100%"
        >
          Nos utilisateurs
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
                  position={column?.Header === 'ACTION' && 'sticky'}
                  right={column?.Header === 'ACTION' && 0}
                  background={column?.Header === 'ACTION' && '#fff'}
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
                  } else if (cell.column.Header === 'NOM') {
                    data = (
                      <Text color={textColor} fontSize="sm" fontWeight="700">
                        {cell.value}
                      </Text>
                    );
                  } else if (cell.column.Header === 'AVATAR') {
                    data = <Avatar src={cell.value} />;
                  } else if (cell.column.Header === 'EMAIL') {
                    data = (
                      <Text color={textColor} fontSize="sm" fontWeight="700">
                        {cell.value}
                      </Text>
                    );
                  } else if (cell.column.Header === 'telephone') {
                    data = (
                      <Text color={textColor} fontSize="sm" fontWeight="700">
                        {cell.value}
                      </Text>
                    );
                  } else if (cell.column.Header === 'PAYS') {
                    data = (
                      <Text color={textColor} fontSize="sm" fontWeight="700">
                        {cell.value}
                      </Text>
                    );
                  } else if (cell.column.Header === 'ID_CARD') {
                    data = (
                      <Text color={textColor} fontSize="sm" fontWeight="700">
                        {cell.value}
                      </Text>
                    );
                  } else if (cell.column.Header === 'STATUT') {
                    data = (
                      <Flex align="center">
                        <Tag
                          size={'md'}
                          variant="outline"
                          colorScheme={
                            cell.value === 'Approved'
                              ? 'green'
                              : cell.value === 'Disabled'
                              ? 'red'
                              : cell.value === 'Pending'
                              ? 'yellow'
                              : null
                          }
                          background={
                            cell.value === 'Approved'
                              ? 'green.100'
                              : cell.value === 'Disabled'
                              ? 'red.100'
                              : cell.value === 'Pending'
                              ? 'yellow.100'
                              : null
                          }
                        >
                          <TagLeftIcon as={BsDot} />
                          <TagLabel>{cell.value}</TagLabel>
                        </Tag>
                      </Flex>
                    );
                  } else if (cell.column.Header === 'CRÉÉ LE') {
                    data = (
                      <Text color={textColor} fontSize="sm" fontWeight="700">
                        {cell.value}
                      </Text>
                    );
                  } else if (cell.column.Header === 'profession') {
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
                      >
                        Editer
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
                      position={cell?.column?.Header === 'ACTION' && 'sticky'}
                      right={cell?.column?.Header === 'ACTION' && 0}
                      background={'#fff'}
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
