import { ethers } from 'ethers';
import { config } from 'dotenv';
config();

let mnemonic = process.env.MNEMONICS!;
let mnemonicWallet = ethers.Wallet.fromPhrase(mnemonic);

console.log("Private Key:", mnemonicWallet.privateKey);
console.log("Address:", mnemonicWallet.address);