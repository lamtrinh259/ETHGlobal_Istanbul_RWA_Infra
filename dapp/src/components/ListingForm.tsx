import { Grid, Box, Center, Tabs, TabList, Tab, TabPanels, TabPanel, Button } from "@chakra-ui/react"
import { DescribeForm } from "./DescribeForm"

export const ListingForm = () => {
    return <Grid w={"100vw"} h="100vh" templateColumns='repeat(2, 1fr)' gap={0}>
        <Box
            backgroundImage={"url(./example-item.png)"}
            backgroundSize={"contain"}
            // backgroundRepeat={"no-repeat"}
            backgroundPosition={"center"}
        />
        <Box w={"full"} h={"full"} pos="relative" backgroundColor={"#E7E8FF"}>
            <Center mt="32">
                <Tabs w={"full"}>
                    <TabList>
                        <Tab>1. Describe</Tab>
                        <Tab>2. Values</Tab>
                        <Tab>3. Confirm</Tab>
                    </TabList>

                    <TabPanels>
                        <TabPanel>
                            <DescribeForm />
                        </TabPanel>
                        <TabPanel>
                            <p>two!</p>
                        </TabPanel>
                        <TabPanel>
                            <p>three!</p>
                        </TabPanel>
                    </TabPanels>
                </Tabs>
            </Center>
            <Box w={"full"} pos={"absolute"} bottom={0} p={8} borderTop={"1px solid #CBCCE0"}>
                <Button>Proceed</Button>
            </Box>
        </Box>

    </Grid >
}