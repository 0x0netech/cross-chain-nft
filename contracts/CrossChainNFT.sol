// SPDX-License-Identifier: MIT
pragma solidity >0.7.0 <0.8.21;

import "./IBridgeNFT.sol";
import "./ICrossChainNft.sol";
import "./openzeppelin/ERC721.sol";
import "./openzeppelin/utils/Strings.sol";

contract CrossChainNft is ERC721, IBridgeNFT, ICrossChainNft {
    using Strings for uint256;

    // The admin of the contract
    address private admin;

    // The link to the metadata storage
    string public baseUri;

    // XP.NETWORK NFT bridge contract address
    address private bridge;

    // The index of the present contract
    uint256 public contractIndex;

    // Difference betwen the upper and lower bounds
    uint256 public range;

    // Holds the next unique identifier
    uint256 private tokenId;

    // Wrapped tokens baseUri
    string public wrappedUri;

    // Hashmap storing the count of claimed NFTs
    mapping(address => uint8) public claimed;

    // The lowerBounds => contract address
    mapping(uint256 => MappedChain) private contractMap;

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
        uint256 contractIndex_,
        uint256 range_,
        string memory baseUri_,
        string memory wrappedUri_
    ) ERC721(name_, symbol_) {
        admin = _msgSender();
        bridge = bridge_;
        contractIndex = contractIndex_;
        range = range_;
        tokenId = _nativeLowerLimit();
        baseUri = baseUri_;
        wrappedUri = wrappedUri_;
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

        if (tokenId + 1 > _nativeLowerLimit()) {
            revert CrossChainNftReachedMintLimit();
        }

        claimed[_msgSender()] += 1;

        tokenId++;

        _safeMint(_msgSender(), tokenId, "");

        emit Claim(_msgSender(), tokenId);
    }

    function nativeLowerLimit() external view returns (uint256) {
        // The smallest tokenId claimable on this chain
        return _nativeLowerLimit();
    }

    function nativeUpperLimit() external view returns (uint256) {
        // The biggest tokenId claimable on this chain
        return _nativeUpperLimit();
    }

    function tokenURI(
        uint256 tokenId_
    ) public view override returns (string memory) {
        _requireMinted(tokenId_);
        if (
            tokenId_ >= _nativeLowerLimit() && tokenId_ <= _nativeUpperLimit()
        ) {
            return baseUri;
        }
        uint256 index_ = tokenId_ / range;
        return
            bytes(wrappedUri).length > 0
                ? string(
                    abi.encodePacked(
                        wrappedUri,
                        contractMap[index_]._chainId,
                        "/",
                        contractMap[index_]._address,
                        "/",
                        tokenId_.toString()
                    )
                )
                : "";
    }

    /********************************************************
     *                O N L Y    A D M I N                  *
     *******************************************************/

    function fixBaseUri(string memory baseUri_) external onlyAdmin {
        baseUri = baseUri_;
    }

    function fixContractIndex(uint256 index_) external onlyAdmin {
        contractIndex = index_;
    }

    function fixRange(uint256 range_) external onlyAdmin {
        range = range_;
    }

    function fixWrappedUri(string memory wrappedUri_) external onlyAdmin {
        wrappedUri = wrappedUri_;
    }

    function mapNewContract(
        uint256 index_,
        string memory address_,
        uint8 chainId_
    ) external onlyAdmin {
        contractMap[index_] = MappedChain(chainId_, address_);
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
        if (id >= _nativeLowerLimit() && id <= _nativeUpperLimit()) {
            revert CrossChainNftWrappedIdOverlapsWithNative(id);
        }
        _safeMint(to, id, mintArgs);
    }

    /********************************************************
     *            P R I V A T E   F U N C T I O N S         *
     *******************************************************/

    function _nativeLowerLimit() private view returns (uint256) {
        return contractIndex * range;
    }

    function _nativeUpperLimit() private view returns (uint256) {
        return _nativeLowerLimit() + range;
    }
}
