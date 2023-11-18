import { Input, InputLeftElement, Text, Box, Center, Flex, Tab, TabList, TabPanel, TabPanels, Tabs, Stack, InputGroup } from "@chakra-ui/react";
import { NextPage } from "next";
import { ItemCard } from "../components/ItemCard";
import { ValuesForm } from "../components/ValuesForm";
import { useAtom } from "jotai";
import { uploadedImgAtom } from "../store/uploaded";
import { SearchIcon } from "@chakra-ui/icons";

const Assets: NextPage = () => {
    const [uploadedImg, _] = useAtom(uploadedImgAtom);
    return <Box
    >
        <Center paddingTop={"150px"} pb={16} pos={"relative"}>
            <Stack alignItems={"center"}>
                <Text fontSize="45px" alignSelf={"center"}>
                    Your Collection
                </Text>
                <Text fontSize="26px">
                    Explore, manage and cherish the assets you’ve tokenized!
                </Text>
                <InputGroup outline={"none"}  p={2} pos={"absolute"} bottom={-4} zIndex={1} bg="#E7E8FF" rounded={"10px"} w={"533px"} border="1px solid rgba(0, 0, 0, 0.16);" shadow={"sm"}>
                    <InputLeftElement pointerEvents='none'>
                        <SearchIcon mt={4} color='gray.300' />
                    </InputLeftElement>
                    <Input border={0} type='tel' placeholder='Search' />
                </InputGroup>
            </Stack>
        </Center>
        <Tabs
            minH={"100vh"}
            bg={"#E5E2FF"}
            px={8} pt={"20px"}
            w={"full"} isLazy variant='soft-rounded' colorScheme='gray'>
            <TabList>
                <Tab>Your Assets</Tab>
                <Tab>Listing</Tab>
            </TabList>

            <TabPanels>
                <TabPanel>
                    <Flex gap={12} flexWrap="wrap" justifyContent="center">
                        {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].map(
                            (i) => <ItemCard key={i} src={i === 1 && !uploadedImg.includes("example") ? uploadedImg : "./example-item.png"} />)}
                    </Flex>
                </TabPanel>
                <TabPanel>
                    <ValuesForm />
                </TabPanel>
            </TabPanels>
        </Tabs>
    </Box>
}

export default Assets;