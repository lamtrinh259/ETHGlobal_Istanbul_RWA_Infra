import { Grid, Box, Center, Tabs, TabList, Tab, TabPanels, TabPanel, Button } from "@chakra-ui/react"
import { useAtom } from "jotai";
import { Stage, stageAtom } from "../store/stage";
import { ConfirmForm } from "./ConfirmForm";
import { DescribeForm } from "./DescribeForm"
import { ValuesForm } from "./ValuesForm";

export const ListingForm = () => {
    const [stage, setStage] = useAtom(stageAtom);

    return <Grid w={"100vw"} h="100vh" templateColumns='repeat(2, 1fr)' gap={0}>
        <Box
            backgroundImage={"url(./example-item.png)"}
            backgroundSize={"contain"}
            // backgroundRepeat={"no-repeat"}
            backgroundPosition={"center"}
        />
        <Box w={"full"} h={"full"} pos="relative" backgroundColor={"#E7E8FF"}>
            <Center mt="32">
                <Tabs w={"full"} index={stage - 1} isLazy>
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
                            <ValuesForm />
                        </TabPanel>
                        <TabPanel>
                            <ConfirmForm />
                        </TabPanel>
                    </TabPanels>
                </Tabs>
            </Center>
            <Box w={"full"} pos={"absolute"} bottom={0} p={8} borderTop={"1px solid #CBCCE0"}>
                {stage !== Stage.confirm && <Button onClick={() => {
                    setStage(stage + 1)
                }}>Proceed</Button>}
                {stage === Stage.confirm && <Button 
                as={"a"}
                href={"/assets"}
                onClick={() => {
                    setStage(stage + 1)
                }}>See your Assets</Button>}
            </Box>
        </Box>

    </Grid >
}