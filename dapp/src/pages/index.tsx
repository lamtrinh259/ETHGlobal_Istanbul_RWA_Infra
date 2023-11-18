import type { NextPage } from "next";
import styles from "../styles/Home.module.css";
import { Text, Box, Button, Flex, Container } from "@chakra-ui/react";
import { useDropzone } from "react-dropzone";
import { createRef, useCallback } from "react";
import { FaCloudUploadAlt } from "react-icons/fa";
import { useAtom } from "jotai";
import { Stage, stageAtom } from "../store/stage";
import { ListingForm } from "../components/ListingForm";

const Home: NextPage = () => {
  const [stage, setStage] = useAtom(stageAtom);

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
          <Button my={8}>
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
    </Container>

  );
};

export default Home;
