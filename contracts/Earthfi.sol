// SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol"; //interface for logging and debugging
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Counters.sol"; //custom counter contract

contract Earthfi is ERC721URIStorage {
    address payable owner;

    using Counters for Counters.Counter;

    Counters.Counter private _productIds;
    Counters.Counter private _productSold;

    uint256 listPrice = 0.01 CELO;

    constructor() ERC721("Earthfi", "ETF") {
        owner = payable(msg.sender);
    }


    struct ListedProducts {
        uint256 productId;
        address payable owner;
        address payable seller;
        string location;
        uint256 price;
        bool currentlyListed;
    }

    mapping (uint256 =>  ListedProducts) private idToListedProduct;

    function updateListPrice(uint256 _listPrice) public payable {
        require(owner == msg.sender, "Only owner can update the listing price")
        listPrice = _listPrice
    }

    function getListprice() public view returns (uint256) {
        return listPrice;
    }

    function getLatestIdToListedToken() public view returns (ListedProducts memory) {
        uint256 currentProductId = _productIds.current();
        return idToListedProduct[productId]
    }

    function getListedForProductId(uint256 productId) public view returns (ListedProducts memory) {
        return idToListedProduct[productId];
    }

    function getCurrentProduct() public view returns (uint256) {
        return _productIds.current();
    }

    function createProduct(string memory productURI, uint256 price) public payable returns (uint) {
        require(msg.value == listPrice, "Send enough ether to list");
        require(price > 0, "make sure the price isn't negative");

        _productIds.increment();
        const currentProductId = _productIds.current();
        _safeMint(msg.sender, currentProductId);

        _setProductURI(currentProductId, productURI);

        createListedProduct(currentProductId, price);

        return currentProductId;
    }

    function createListedProduct() {}

    function getAllProducts() {}

    function getMyProduct() {}

    function executeSale() {}

}
