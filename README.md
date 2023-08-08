# Cross Chain NFT Contracts

A set of connected NFT smart contracts that can be deployed on several chains and be safely minted and bridged without the danger of `tokenId` overlapping.

## Installing

Run in the terminal

```shell
git clone https://github.com/XP-NETWORK/cross-chain-nft.git
cd cross-chain-nft/
yarn
```

## Using the contract

#### 1. Flatten the contract

Run in the terminal:

```shell
npx hardhat flatten ./contracts/CrossChainNFT.sol > ./contracts/CrossChainNFT_flat.sol
```

#### 2. Hide the split contracts

Delete or comment out the old contracts, especially `CrossChainNft.sol`.

#### 3. Populate `.env`

1. rename `.env.example` to `.env`

```shell
mv .env.example .env
```

2. Populate the variables to avoid errors during the compilation & deployment stages. If you already have the private key you only need to populate the SK= field. If this field is not populated, the `hardhat.config.ts` won't work correctly.

```shell
# Private Key of the deployer
SK=
# Deployer mnemonics Example="test test test"
MNEMONICS=
```

3. If you only have mnemonics, populate the MNEMONICS= according to the example. Then run in the terminal:

```shell
ts-node ./scripts/mnem_to_sk.ts
```
As a result, you will get your private key and the address. Compare the address with the one you see in the wallet. If they match, you've correctly generated the private key to populate the SK= filed.

#### 4. Compile

Run in the terminal

```shell
npx hardhat compile
```