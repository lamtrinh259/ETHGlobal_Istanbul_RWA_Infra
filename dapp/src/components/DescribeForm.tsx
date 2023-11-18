import { Box, HStack, Input, Select, Stack, Text, Textarea } from "@chakra-ui/react"

export const DescribeForm = () => {
    return <Stack pl={2} pr={4} gap={4}>
        <Text
            color={"rgba(116, 122, 142, 0.50)"}>Name it, define it, share its story – breathe life into your item with essential details</Text>

        <Box>
            <Text mb={2}>Item name</Text>
            <Input
                backgroundColor={"#D8DAF6"}
                placeholder="The more descriptive the better"></Input>
        </Box>

        <HStack w={"full"} gap={4}>
            <Box flexGrow={1}>
                <Text mb={2}>Product Category</Text>
                <Select
                    backgroundColor={"#D8DAF6"}
                    placeholder='Select option'>
                    <option value='option1'>Jewellery</option>
                    <option value='option2'>Watch</option>
                    <option value='option3'>Sunglass</option>
                    <option value='option3'>Electronics</option>
                </Select>
            </Box>
            <Box flexGrow={1}>
                <Text mb={2}>Product Condition</Text>
                <Select
                    backgroundColor={"#D8DAF6"}
                    placeholder='Select option'>
                    <option value='option1'>New</option>
                    <option value='option2'>Good</option>
                    <option value='option3'>Acceptable</option>
                    <option value='option4'>Damaged</option>
                </Select>
            </Box>
        </HStack>

        <Box>
            <Text mb={2}>Item Description</Text>
            <Textarea
                minH={"150px"}
                backgroundColor={"#D8DAF6"}
                placeholder='Write some description for your item.' />
        </Box>
    </Stack>

}