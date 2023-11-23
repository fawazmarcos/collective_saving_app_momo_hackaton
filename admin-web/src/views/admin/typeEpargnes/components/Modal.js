import {
  Button,
  Checkbox,
  FormControl,
  FormLabel,
  Input,
  Modal,
  ModalOverlay,
  ModalContent,
  ModalHeader,
  ModalFooter,
  ModalBody,
  ModalCloseButton,
  useDisclosure,
  useToast,
} from '@chakra-ui/react';
import React from 'react';
import { database } from 'config/firebase-config';
import { addDoc, collection } from 'firebase/firestore';
import moment from 'moment';
// import { BeatLoader } from "@chakra-ui/icons"

export default function CreateModal({ getAllTransactions }) {
  const { isOpen, onOpen, onClose } = useDisclosure();

  const initialRef = React.useRef(null);
  const finalRef = React.useRef(null);

  const toast = useToast();
  const [description, setDescription] = React.useState();
  const [libelle, setLibelle] = React.useState();
  const [checkedItems, setCheckedItems] = React.useState(false);
  const [loading, setLoading] = React.useState(false);

  const typeofsavingsCollectionRef = React.useMemo(
    () => collection(database, 'types_epargne'),
    []
  );

  const onSubmit = async () => {
    setLoading(true);
    try {
      await addDoc(typeofsavingsCollectionRef, {
        libelle: libelle,
        description: description,
        createdAt: moment(Date.now()).format('DD-MM-YYYY'),
        bourse: checkedItems,
      });

      getAllTransactions();
      setLoading(false);
      onClose();
      toast({
        position: 'top-right',
        title: "Créationde type d'épargne!",
        description: "L'épargne a été créée avec succès",
        status: 'success',
        duration: 5000,
        isClosable: true,
      });
    } catch (e) {
      setLoading(false);
      console.log('errrr', e);
    }
  };

  return (
    <>
      <Button colorScheme="blue" onClick={onOpen}>
        Créer un type d'épargne
      </Button>

      <Modal
        initialFocusRef={initialRef}
        finalFocusRef={finalRef}
        isOpen={isOpen}
        onClose={onClose}
      >
        <ModalOverlay />
        <ModalContent>
          <ModalHeader>Créer un type d'épargne</ModalHeader>
          <ModalCloseButton />
          <ModalBody pb={6}>
            <FormControl>
              <FormLabel>Libellé</FormLabel>
              <Input
                onChange={e => setLibelle(e.target.value)}
                ref={initialRef}
                placeholder="Libellé"
              />
            </FormControl>

            <FormControl mt={4}>
              <FormLabel>Description</FormLabel>
              <Input
                onChange={e => setDescription(e.target.value)}
                placeholder="Description"
              />
            </FormControl>
            <FormControl mt={4}>
              <Checkbox
                value={checkedItems}
                onChange={e => setCheckedItems(e.target.checked)}
              >
                Subventionné
              </Checkbox>
            </FormControl>
          </ModalBody>

          <ModalFooter>
            <Button
              isLoading={loading}
              colorScheme="blue"
              // spinner={<BeatLoader size={8} color="white" />}
              variant="solid"
              mr={3}
              onClick={onSubmit}
            >
              Enregistrer
            </Button>
            <Button onClick={onClose}>Annuler</Button>
          </ModalFooter>
        </ModalContent>
      </Modal>
    </>
  );
}
