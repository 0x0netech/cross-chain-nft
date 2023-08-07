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

#### 2. Fix in the ERC721:

From:
```solidity
    // Token name
    string private _name;

    // Token symbol
    string private _symbol;
```

Fix to:

```solidity
    // Token name
    string internal _name;

    // Token symbol
    string internal _symbol;
```

#### 3. Hide the split contracts

Delete or comment out the old contracts, especially `CrossChainNft.sol`.

#### 4. Compile

Run in the terminal

```shell
npx hardhat compile
```