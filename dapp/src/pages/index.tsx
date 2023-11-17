import type { NextPage } from "next";
import styles from "../styles/Home.module.css";
import { Text, Box, Button, Flex } from "@chakra-ui/react";
import { useDropzone } from "react-dropzone";
import { createRef, useCallback } from "react";
import { FaCloudUploadAlt } from "react-icons/fa";

const Home: NextPage = () => {
  // const [files, setFiles] = useState([]);
  const onDrop = useCallback(
    async (acceptedFiles: any) => {
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

  return (
    <div className={styles.container}>
      <main className={styles.main}>
        <h1 className={styles.title}>
          Where the digital meets the tangible.
        </h1>
        <h2>
          Bring the physical into the digital realm seamlessly
        </h2>
        <Button>
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
            border="white 2px dashed"
            rounded="40px"
            minH={{ base: "50vh", xl: "40vh" }}
            bg="blackAlpha.400"
            direction="column"
            transitionDuration="300ms"
            alignItems="center"
            _hover={{ background: "blackAlpha.500" }}
            justify="center"
            color="#FFE4E8"
            py="10"
            mb="10"
          >
            <FaCloudUploadAlt size="60px" />
            <Text fontFamily="secondary" fontWeight="normal" mt="2">
              Drag & Drop a file here to get started!
            </Text>
          </Flex>
        </Box>
      </main>
    </div>
  );
};

export default Home;
