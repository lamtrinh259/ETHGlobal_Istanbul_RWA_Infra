import { Box, Flex, Tab, TabList, TabPanel, TabPanels, Tabs } from "@chakra-ui/react";
import { NextPage } from "next";
import { ItemCard } from "../components/ItemCard";
import { ValuesForm } from "../components/ValuesForm";
import { useAtom } from "jotai";
import { uploadedImgAtom } from "../store/uploaded";

const Assets: NextPage = () => {
    const [uploadedImg, _] = useAtom(uploadedImgAtom);
    return <Box
        bg={"#E5E2FF"}
        minH={"100vh"}
        px={8} pt={"140px"}>
        <Tabs w={"full"} isLazy variant='soft-rounded' colorScheme='gray'>
            <TabList>
                <Tab>Your Assets</Tab>
                <Tab>Listing</Tab>
            </TabList>

            <TabPanels>
                <TabPanel>
                    <Flex gap={8} flexWrap="wrap">
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