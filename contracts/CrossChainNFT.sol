// SPDX-License-Identifier: MIT
pragma solidity >0.7.0 <0.8.20;

import "./IBridgeNFT.sol";
import "./ICrossChainNft.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract CrossChainNft is ERC721, IBridgeNFT, ICrossChainNft {
    using Strings for uint256;

    // The admin of the contract
    address private admin;

    // The link to the metadata storage
    string public baseUri;

    // XP.NETWORK NFT bridge contract address
    address private bridge;

    // The smallest tokenId claimable on this chain
    uint256 public nativeLowerLimit;

    // The biggest tokenId claimable on this chain
    uint256 public nativeUpperLimit;

    // Holds the next unique identifier
    uint256 private tokenId;

    // Hashmap storing the count of claimed NFTs
    mapping(address => uint8) public claimed;

    modifier onlyAdmin() {
        if (_msgSender() != admin) {
            revert ERC721InvalidSender(_msgSender());
        }
        _;
    }

    modifier onlyBridge() {
        if (_msgSender() != bridge) {
            revert ERC721InvalidSender(_msgSender());
        }
        _;
    }

    constructor(
        string memory name_,
        string memory symbol_,
        address bridge_,
        uint256 lowerLimit_,
        uint256 upperLimit_,
        string memory baseUri_
    ) ERC721(name_, symbol_) {
        admin = _msgSender();
        bridge = bridge_;
        nativeLowerLimit = lowerLimit_;
        nativeUpperLimit = upperLimit_;
        tokenId = lowerLimit_;
        baseUri = baseUri_;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721) returns (bool) {
        return
            interfaceId == type(IBridgeNFT).interfaceId ||
            interfaceId == type(ICrossChainNft).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function baseURI() external view returns (string memory) {
        return baseUri;
    }

    function claim() external {
        if (_msgSender().code.length > 0) {
            revert CrossChainNftContractsCannotClaim(_msgSender());
        }
        if (claimed[_msgSender()] == 5) {
            revert CrossChainNftReachedClaimLimit(_msgSender());
        }

        if (tokenId + 1 > nativeUpperLimit) {
            revert CrossChainNftReachedMintLimit();
        }

        claimed[_msgSender()] += 1;

        tokenId++;

        _safeMint(_msgSender(), tokenId, "");

        emit Claim(_msgSender(), tokenId);
    }

    function tokenURI(
        uint256 tokenId_
    ) public view override returns (string memory) {
        _requireMinted(tokenId_);
        return
            bytes(baseUri).length > 0
                ? string(abi.encodePacked(baseUri, tokenId_.toString()))
                : "";
    }

    /********************************************************
     *                O N L Y    A D M I N                  *
     *******************************************************/

    function fixBaseUri(string memory baseUri_) external onlyAdmin {
        baseUri = baseUri_;
    }

    function fixLowerLimit(uint256 limit_) external onlyAdmin {
        nativeUpperLimit = limit_;
    }

    function fixUpperLimit(uint256 limit_) external onlyAdmin {
        nativeLowerLimit = limit_;
    }

    function renounceAdmin() external onlyAdmin {
        admin = address(0);
    }

    function updateBridge(address bridge_) external onlyAdmin {
        bridge = bridge_;
    }

    function updateName(string memory name_) external onlyAdmin {
        _name = name_;
    }

    function updateSymbol(string memory symbol_) external onlyAdmin {
        _symbol = symbol_;
    }

    /********************************************************
     *              O N L Y    B R I D G E                  *
     *******************************************************/

    function burnFor(address to, uint256 tokenId_) external onlyBridge {
        if (!_isApprovedOrOwner(_msgSender(), tokenId_)) {
            revert ERC721InsufficientApproval(_msgSender(), tokenId_);
        }
        if (ownerOf(tokenId_) != to) {
            revert ERC721IncorrectOwner(to, tokenId_, ownerOf(tokenId_));
        }
        _burn(tokenId_);
    }

    function mint(
        address to,
        uint256 id,
        bytes calldata mintArgs
    ) external onlyBridge {
        if (id >= nativeLowerLimit && id <= nativeUpperLimit) {
            revert CrossChainNftWrappedIdOverlapsWithNative(id);
        }
        _safeMint(to, id, mintArgs);
    }
}
