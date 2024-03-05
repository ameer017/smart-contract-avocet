// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract Plastik {
    struct Order {
        uint256 orderID;
        address owner;
        uint256 price;
        uint256 weight;
        string orderTitle;
        string images;
        string location;
        string description;
    }

    address payable contractOwner =
        payable(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
    uint256 public listingPrice = 0.015 ether;
    mapping(uint256 => Order) private orders;
    uint256 public orderIndex;

    event OrderListed(uint256 indexed id, address indexed owner, uint256 price);
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
            "only owner of the contract can change the price"
        );
        _;
    }

    function listPlastik(
        address owner,
        uint256 price,
        uint256 weight,
        string memory _orderTitle,
        string memory _images,
        string memory _location
    )
        external
        returns (uint256, string memory, uint256, string memory, string memory)
    {
        require(price > 0, "Price must be greater than 0.");
        require(weight > 5, "Weight value must be greater than 5kg."); //the least amount of plastic is 5kg
        orderIndex++;
        uint256 orderId = orderIndex;
        Order storage order = orders[orderId];

        order.orderID = orderId;
        order.owner = owner;
        order.price = price;
        order.weight = weight;
        order.orderTitle = _orderTitle;
        order.images = _images;
        order.location = _location;

        emit OrderListed(orderId, owner, price);

        return (orderId, _orderTitle, weight, _images, _location);
    }

    function updatePlastik(
        address owner,
        uint256 orderId,
        string memory _orderTitle,
        string memory _images,
        string memory _location,
        uint256 weight
    )
        external
        returns (uint256, string memory, uint256, string memory, string memory)
    {
        Order storage order = orders[orderId];
        require(order.owner == owner, "You are not an owner");
        order.orderTitle = _orderTitle;
        order.images = _images;
        order.location = _location;
        order.weight = weight;

        return (orderId, _orderTitle, weight, _images, _location);
    }

    function updatePrice(
        address owner,
        uint256 orderId,
        uint256 price
    ) external returns (string memory) {
        Order storage order = orders[orderId];
        require(order.owner == owner, "You are not an owner");

        order.price = price;

        return "Your order Price Is Updated";
    }

    function buyPlastik(uint256 id, address buyer) external payable {
        uint256 amount = msg.value;

        require(amount == orders[id].price, "Insufficient funds.");

        Order storage order = orders[id];

        (bool sent, ) = payable(order.owner).call{value: amount}("");

        if (sent) {
            order.owner = buyer;
            emit OrderSold(id, order.owner, buyer, amount);
        }
    }

    function getAllPlastiks() public view returns (Order[] memory) {
        uint256 itemCount = orderIndex;
        uint256 currentIndex = 0;

        Order[] memory items = new Order[](itemCount);
        for (uint256 i = 0; i < itemCount; i++) {
            uint256 currentId = i + 1;
            Order storage currentItem = orders[currentId];
            items[currentIndex] = currentItem;
            currentIndex += 1;
        }
        return items;
    }

    function getPlastik(
        uint256 id
    )
        external
        view
        returns (
            uint256,
            uint256,
            address,
            uint256,
            string memory,
            string memory,
            string memory
        )
    {
        Order memory order = orders[id];
        return (
            order.orderID,
            order.weight,
            order.owner,
            order.price,
            order.orderTitle,
            order.images,
            order.location
        );
    }

    function getUserPlastiks(
        address user
    ) external view returns (Order[] memory) {
        uint256 totalItemCount = orderIndex;
        uint256 itemCount = 0;
        uint256 currentIndex = 0;
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (orders[i + 1].owner == user) {
                itemCount += 1;
            }
        }

        Order[] memory items = new Order[](itemCount);
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (orders[i + 1].owner == user) {
                uint256 currentId = i + 1;
                Order storage currentItem = orders[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    //RETURN LISTING PRICE
    function getListingPrice() public view returns (uint256) {
        return listingPrice;
    }

    function updateListingPrice(
        uint256 _listingPrice,
        address owner
    ) public payable onlyOwner {
        require(
            contractOwner == owner,
            "Only contract owner can update listing price."
        );
        listingPrice = _listingPrice;
    }
}
