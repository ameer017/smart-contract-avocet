// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract EcoCycle is ERC20 {
    address public owner;

    constructor(uint256 initialSupply) ERC20("Ecocycle", "ECY") {
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }

    function mint(uint256 amount) external {
        require(msg.sender == owner, "Only owner can mint");
        _mint(msg.sender, amount * 10 ** 18); 
    }
}
