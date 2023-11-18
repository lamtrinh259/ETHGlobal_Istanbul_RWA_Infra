import type { NextPage } from "next";
import styles from "../styles/Home.module.css";
import { Text, Box, Button, Flex, Container, useDisclosure, Modal, ModalOverlay, ModalContent, ModalHeader, ModalCloseButton, ModalBody, ModalFooter } from "@chakra-ui/react";
import { useDropzone } from "react-dropzone";
import { createRef, useCallback, useState } from "react";
import { FaCloudUploadAlt } from "react-icons/fa";
import { useAtom } from "jotai";
import { Stage, stageAtom } from "../store/stage";
import { ListingForm } from "../components/ListingForm";
import QRCode from "react-qr-code";
import { request } from "../Reusables/request";
import { uploadedImgAtom } from "../store/uploaded";

const Home: NextPage = () => {
  const [stage, setStage] = useAtom(stageAtom);
  const [uploadedImg, seUploadedImg] = useAtom(uploadedImgAtom);
  const [isLoading, setIsLoading] = useState(false);

  const { isOpen, onOpen, onClose } = useDisclosure()

  const onDrop = useCallback(
    async (acceptedFiles: any) => {
      setStage(Stage.describe);

      // setFiles(acceptedFiles);
      // if (address) {
      //   //console.log(address);
      //   onApproveOpen();
      //   //console.log(acceptedFiles);
      // } else {
      //   onApproveOpen();
      //   onConnectOpen();
      // }
    },
    []
  );

  const { getRootProps, getInputProps, isDragActive } = useDropzone({ onDrop });
  const dropZoneRef: React.LegacyRef<HTMLDivElement> | undefined =
    createRef();

  if (stage !== Stage.uploading) {
    return <ListingForm />
  }

  // it's uploading staging
  return (
    <Container maxW="container.md">
      <div className={styles.container}>
        <main className={styles.main}>
          <h1 className={styles.title}>
            Where the <Text display={"inline"} fontFamily="cursive">digital</Text> meets the <Text display={"inline"} fontFamily="cursive">tangible</Text>.
          </h1>
          <Text my={2} fontSize="2xl">
            Bring the physical into the digital realm seamlessly
          </Text>

          <Button my={8} onClick={onOpen}>
            Take a photo
          </Button>
          <h2>
            OR
          </h2>
          <Box w={"full"}>
            <input
              style={{ display: "none" }}
              {...getInputProps()}
              type="file"
              accept="*"
            />
            <Flex
              {...getRootProps()}
              w="full"
              cursor="pointer"
              ref={dropZoneRef}
              mt="6"
              backdropFilter="blur(20px)"
              border="2px dashed #000"
              rounded="45px"
              minH={{ base: "50vh", xl: "40vh" }}
              bg="rgba(255, 255, 255, 0.09)"
              direction="column"
              transitionDuration="300ms"
              alignItems="center"
              _hover={{ background: "blackAlpha.100" }}
              justify="center"
              py="10"
              mb="10"
            >
              <FaCloudUploadAlt size="60px" />
              <Text fontWeight="normal" mt="2">
                Drag & Drop a file here to get started!
              </Text>
            </Flex>
          </Box>
        </main>
      </div>
      <Modal isOpen={isOpen} onClose={onClose}>
        <ModalOverlay />
        <ModalContent>
          <ModalHeader>Scan the QRCode to take photo</ModalHeader>
          <ModalCloseButton />
          <ModalBody>
            <QRCode
              size={256}
              style={{ height: "auto", maxWidth: "100%", width: "100%" }}
              value={window.location.href + '/camera'}
              viewBox={`0 0 256 256`}
            />
          </ModalBody>

          <ModalFooter>
            <Button colorScheme='blue' mr={3} onClick={onClose}>
              Close
            </Button>
            <Button isLoading={isLoading} colorScheme='blue' mr={3} onClick={async () => {
              setIsLoading(true);
              const img = await request<{ data: string }>("/api/upload-image", "GET");
              seUploadedImg(img.data);
              setIsLoading(false);
              setStage(Stage.describe);
            }}>
              Done
            </Button>
          </ModalFooter>
        </ModalContent>
      </Modal>
    </Container>

  );
};

export default Home;
