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
# For Polygon Mumbai
$ forge script ./script/Deployer.s.sol:DeployerScript --rpc-url $MUMBAI_RPC_URL --broadcast --verify -vvvv --private-key $PRIVATE_KEY
# For Polygon Mainnet
$ forge script ./script/Deployer.s.sol:DeployerScript --rpc-url $POLYGON_RPC_URL --broadcast --verify -vvvv --private-key $PRIVATE_KEY
# For Scroll Sepolia
$ forge script ./script/Deployer.s.sol:DeployerScript --rpc-url $SCROLL_SEPOLIA_RPC_URL --broadcast --verify -vvvv --private-key $PRIVATE_KEY --legacy
```

### Verify command

```shell
# For Scroll Sepolia
forge verify-contract $CONTRACT_ADDRESS Marketplace \
  --verifier-url https://api-sepolia.scrollscan.com/api \
  --etherscan-api-key $SCROLLSCAN_API_KEY \
  --constructor-args $(cast abi-encode "constructor(address)" $DEPLOYER_ADDRESS)

# For Polygon Mumbai
forge verify-contract $CONTRACT_ADDRESS Marketplace \
  --verifier-url https://api-mumbai.polygonscan.com/api \
  --etherscan-api-key $POLYGONSCAN_API_KEY \
  --constructor-args $(cast abi-encode "constructor(address)" $DEPLOYER_ADDRESS)
```
