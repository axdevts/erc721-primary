// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AncientShrooms is ERC721, Ownable {
    using Strings for string;

    uint256 public constant MAX_TOKENS = 150;
    uint256 public constant NUMBER_RESERVED_TOKENS = 300;
    uint256 public constant PRICE = 000000000000000;

    uint256 public constant OG_SALE_MAX_TOKENS = 150;
    uint256 public constant PRE_SALE_MAX_TOKENS = 0;

    bool public saleIsActive = false;
    bool public ogSaleIsActive = false;
    bool public preSaleIsActive = false;

    uint256 public reservedTokensMinted = 0;
    uint256 public supply = 0;
    uint256 public preSaleSupply = 0;
    uint256 public ogSaleSupply = 0;
    string private _baseTokenURI;

    address payable private devguy =
        payable(0x6D86bee8768724Aff0147631953a2bE67228a520);

    constructor() ERC721("Magic Mushroom Clubhouse", "ANCIENTSHROOM") {}

    function mintToken(uint256 amount) external payable {
        require(saleIsActive, "Sale must be active to mint");
        require(
            supply + amount <=
                MAX_TOKENS - (NUMBER_RESERVED_TOKENS - reservedTokensMinted),
            "Purchase would exceed max supply"
        );
        require(msg.value >= PRICE * amount, "Not enough ETH for transaction");

        for (uint256 i = 0; i < amount; i++) {
            _safeMint(msg.sender, supply);
            supply++;
        }
    }

    function mintTokenOgSale(uint256 amount) external payable {
        require(ogSaleIsActive, "OG-sale must be active to mint");
        require(msg.value >= PRICE * amount, "Not enough ETH for transaction");
        require(
            ogSaleSupply + amount <= OG_SALE_MAX_TOKENS,
            "Purchase would exceed max supply for OG sale"
        );
        require(
            balanceOf(msg.sender) + amount <= 2,
            "Limit is 2 tokens per wallet, sale not allowed"
        );

        for (uint256 i = 0; i < amount; i++) {
            _safeMint(msg.sender, supply);
            supply++;
            ogSaleSupply++;
        }
    }

    function mintTokenPreSale(uint256 amount) external payable {
        require(preSaleIsActive, "Pre-sale must be active to mint");
        require(msg.value >= PRICE * amount, "Not enough ETH for transaction");
        require(
            preSaleSupply + amount <= PRE_SALE_MAX_TOKENS,
            "Purchase would exceed max supply for pre sale"
        );
        require(
            balanceOf(msg.sender) + amount <= 5,
            "Limit is 5 tokens per wallet, sale not allowed"
        );

        for (uint256 i = 0; i < amount; i++) {
            _safeMint(msg.sender, supply);
            supply++;
            preSaleSupply++;
        }
    }

    function flipSaleState() external onlyOwner {
        saleIsActive = !saleIsActive;
    }

    function flipPreSaleState() external onlyOwner {
        preSaleIsActive = !preSaleIsActive;
    }

    function flipOgSaleState() external onlyOwner {
        ogSaleIsActive = !ogSaleIsActive;
    }

    function mintReservedTokens(uint256 amount) external onlyOwner {
        require(
            reservedTokensMinted + amount <= NUMBER_RESERVED_TOKENS,
            "This amount is more than max allowed"
        );

        for (uint256 i = 0; i < amount; i++) {
            _safeMint(owner(), supply);
            supply++;
            reservedTokensMinted++;
        }
    }

    function withdraw() external {
        require(
            msg.sender == devguy || msg.sender == owner(),
            "Invalid sender"
        );

        uint256 devPart = (address(this).balance / 100) * 2;
        devguy.transfer(devPart);
        payable(owner()).transfer(address(this).balance);
    }

    ////
    //URI management part
    ////

    function _setBaseURI(string memory baseURI) internal virtual {
        _baseTokenURI = baseURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string memory baseURI) external onlyOwner {
        _setBaseURI(baseURI);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721)
        returns (string memory)
    {
        string memory _tokenURI = super.tokenURI(tokenId);
        return
            bytes(_tokenURI).length > 0
                ? string(abi.encodePacked(_tokenURI, ".json"))
                : "";
    }
}
