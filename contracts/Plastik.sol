// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract Plastic {
    struct Order {
        uint256 orderID;
        address owner;
        uint256 price;
        string orderTitle;
        string location;
        string images;
        string orderAddress;
    }

    address payable contractOwner =
        payable(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
    uint256 public listingPrice = 0.015 ether;
    mapping(uint256 => Order) private orders;
    uint256 public orderIndex;

    event OrderListed(
        uint256 indexed id,
        address indexed owner,
        uint256 price
    );
    event OrderSold(
        uint256 indexed id,
        address indexed oldOwner,
        address indexed newOwner,
        uint256 price
    );
    event OrderResold(
        uint256 indexed id,
        address indexed oldOwner,
        address indexed newOwner,
        uint256 price
    );

    modifier onlyOwner() {
        require(
            msg.sender == contractOwner,
            "only owner of the contract can change the listing price"
        );
        _;
    };


    function listOrder(address owner, uint256 price, string memory _orderTitle,
     string memory _images, string memory _orderAddress, string memory _location
     ) external returns (uint256, string memory, string memory, string memory, string memory ) {
        require(price > 0, "Price must be greater than 0.");
         orderIndex++;
         uint256 orderID = orderIndex;
         Order storage order = orders[orderID];

            order.orderID = orderId;
         order.owner = owner;
         order.price = price;
         order.orderTitle = _orderTitle;
         order.images = _images;
         order.orderAddress = _orderAddress;
         order.location = _location
        
        emit OrderListed(orderID, owner, price);

        return ( orderId, _orderTitle, _images, _location);
    }

    function updatePrice(address owner, uint256 orderId, uint256 price) external returns (string memory){

        Order storage Order = orders[orderId];
        require(Order.owner == owner, "You are not an owner");

        Order.price = price;

        return "Your Property Price Is Updated";

    }
    
    function buyPlastic(uint256 id,  address buyer) external payable {
        uint256 amount = msg.value;

        require(amount == orders[id].price, "Insufficient funds.");

        Order storage Order = orders[id];

        (bool sent,) = payable(Order.owner).call{value: amount}("");

        if(sent) {
        order.owner = buyer;
        emit OrderSold(id, property.owner, buyer, amount);
        }
        
    }
    
    constructor() {}
}
