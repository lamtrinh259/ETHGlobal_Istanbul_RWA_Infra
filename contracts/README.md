## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

### Deploy command

```shell
# For Scroll Sepolia
$ forge script ./script/Deployer.s.sol:DeployerScript --rpc-url $SCROLL_SEPOLIA_RPC_URL --broadcast -vvvv --private-key $PRIVATE_KEY --legacy
# For Celo Alfajores
$ forge script ./script/Deployer.s.sol:DeployerScript --rpc-url $CELO_ALFAJORES_RPC_URL --broadcast -vvvv --private-key $PRIVATE_KEY
# For Base Goerli
$ forge script ./script/Deployer.s.sol:DeployerScript --rpc-url $BASE_GOERLI_RPC_URL --broadcast -vvvv --private-key $PRIVATE_KEY
# For Arbitrum Goerli
$ forge script ./script/Deployer.s.sol:DeployerScript --rpc-url $ARBITRUM_GOERLI_RPC_URL --broadcast -vvvv --private-key $PRIVATE_KEY --legacy
# For Linea Goerli
$ forge script ./script/Deployer.s.sol:DeployerScript --rpc-url $LINEA_GOERLI_RPC_URL --broadcast -vvvv --private-key $PRIVATE_KEY
# For Mantle Testnet
$ forge script ./script/Deployer.s.sol:DeployerScript --rpc-url $MANTLE_TESTNET_RPC_URL --broadcast -vvvv --private-key $PRIVATE_KEY
# For Gnosis Mainnet
forge script ./script/Deployer.s.sol:DeployerScript --rpc-url $GNOSIS_RPC_URL --broadcast -vvvv --private-key $PRIVATE_KEY
```

### Verify command

```shell

# For Scroll Sepolia
forge verify-contract $CONTRACT_ADDRESS Marketplace \
  --verifier-url https://api-sepolia.scrollscan.com/api \
  --etherscan-api-key $SCROLLSCAN_API_KEY \
  --constructor-args $(cast abi-encode "constructor(address)" $DEPLOYER_ADDRESS)

# For Celo Alfajores
forge verify-contract $CONTRACT_ADDRESS Marketplace \
  --verifier-url https://api-alfajores.celoscan.io/api \
  --etherscan-api-key $CELOSCAN_API_KEY \
  --constructor-args $(cast abi-encode "constructor(address)" $DEPLOYER_ADDRESS)

# For Base Goerli
forge verify-contract $CONTRACT_ADDRESS Marketplace \
  --verifier-url https://api-goerli.basescan.org/api \
  --etherscan-api-key $BASESCAN_API_KEY \
  --constructor-args $(cast abi-encode "constructor(address)" $DEPLOYER_ADDRESS)

# For Arbitrum Goerli
forge verify-contract $CONTRACT_ADDRESS Marketplace \
  --verifier-url https://api-goerli.arbiscan.io/api \
  --etherscan-api-key $ARBISCAN_API_KEY \
  --constructor-args $(cast abi-encode "constructor(address)" $DEPLOYER_ADDRESS)

# For Linea Goerli
forge verify-contract $CONTRACT_ADDRESS Marketplace \
  --verifier-url https://api-testnet.lineascan.build/api \
  --etherscan-api-key $LINEASCAN_API_KEY \
  --constructor-args $(cast abi-encode "constructor(address)" $DEPLOYER_ADDRESS)

# For Mantle Testnet
forge verify-contract $CONTRACT_ADDRESS Marketplace \
    --verifier blockscout --watch \
	--verifier-url "https://explorer.testnet.mantle.xyz/api?module=contract&action=verify" \
    --constructor-args $(cast abi-encode "constructor(address)" $DEPLOYER_ADDRESS)

# For Gnosis Mainnet
forge verify-contract $CONTRACT_ADDRESS Marketplace \
  --verifier-url https://api.gnosisscan.io/api  \
  --etherscan-api-key $GNOSISSCAN_API_KEY \
  --constructor-args $(cast abi-encode "constructor(address)" $DEPLOYER_ADDRESS)
```

### Contract addresses

- Scroll Sepolia: (0xD533833fe737150C8935D57039398CC5322f2dAb)[https://sepolia.scrollscan.dev/address/0xD533833fe737150C8935D57039398CC5322f2dAb]
- Celo Alfajores: (0x485247D991959C04A2D80a625647adD3Ce45CE6C)[https://alfajores.celoscan.io/address/0x485247D991959C04A2D80a625647adD3Ce45CE6C]
- Base Goerli: (0x485247D991959C04A2D80a625647adD3Ce45CE6C)[https://goerli.basescan.org/address/0x485247D991959C04A2D80a625647adD3Ce45CE6C]
- Arbitrum Goerli: (0x485247D991959C04A2D80a625647adD3Ce45CE6C)[https://goerli.arbiscan.io/address/0x485247D991959C04A2D80a625647adD3Ce45CE6C]
- Linea Testnet: (0x485247D991959C04A2D80a625647adD3Ce45CE6C)[https://testnet.lineascan.build/address/0x485247D991959C04A2D80a625647adD3Ce45CE6C]
- Mantle Testnet: (0x485247D991959C04A2D80a625647adD3Ce45CE6C)[https://explorer.testnet.mantle.xyz/address/0x485247D991959C04A2D80a625647adD3Ce45CE6C]
- Gnosis Mainnet: (0x485247D991959C04A2D80a625647adD3Ce45CE6C)[https://gnosisscan.io/address/0x485247D991959C04A2D80a625647adD3Ce45CE6C]
