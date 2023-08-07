// SPDX-License-Identifier: MIT
pragma solidity >0.7.0 <0.8.20;

interface ICrossChainNft {

    struct MappedChain {
        uint8 _chainId;
        string _address;
    }

    /**
     * @dev Indicates attempt to mint 
     */
    error CrossChainNftWrappedIdOverlapsWithNative(uint256 id);

    /**
     * @dev Indicates attempt to claim by a contract
     * @param sender Address which tried to claim
     */
    error CrossChainNftContractsCannotClaim(address sender);

    /**
     * @dev Indicates attempt to claim > 5 per account
     * @param sender Address who tried to claim
     */
    error CrossChainNftReachedClaimLimit(address sender);

    /**
     * @dev Indicates attempt to mint > 1M per contract
     */
    error CrossChainNftReachedMintLimit();

    /**
     * @dev Indicates a failure with the token `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     */
    error ERC721InvalidSender(address sender);

    /**
     * @dev Indicates a failure with the `operator`’s approval. Used in transfers.
     * @param operator Address that may be allowed to operate on tokens without being their owner.
     * @param tokenId Identifier number of a token.
     */
    error ERC721InsufficientApproval(address operator, uint256 tokenId);

    /**
     * @dev Indicates an error related to the ownership over a particular token. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     * @param tokenId Identifier number of a token.
     * @param owner Address of the current owner of a token.
     */
    error ERC721IncorrectOwner(address sender, uint256 tokenId, address owner);

    /**
     * @dev Emmited when a `user` claimed an NFT with `tokenId`
     * @param user an EOA claiming an NFT
     * @param tokenId the unique identifier of the minted token
     */
    event Claim(address indexed user, uint256 indexed tokenId);

    /**
     * @dev Mints an NFT to the sender
     * 
     * Requirements:
     * 
     * - The sender must have less than 5 claimed NFTs
     * - The contract must have less than 1M minted NFTs
     * - The sender must be an EOA and not a contract
     * 
     * Emits a {Claim} event.
     */
    function claim() external;
}