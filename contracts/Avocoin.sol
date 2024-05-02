// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface ERC20Interface {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint balance);

    function transfer(
        address recipient,
        uint amount
    ) external returns (bool success);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint remaining);

    function approve(
        address spender,
        uint amount
    ) external returns (bool success);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool success);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract Avocoin is ERC20Interface {
    string public symbol;
    string public name;
    uint8 public decimals;
    uint public _totalSupply;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    constructor() {
        symbol = "AVC";
        name = "Avocoin";
        decimals = 18;
        _totalSupply = 1_000_900_000_000_000_000_000_000;
        balances[0xc7Df83388E55ee0c2972e4765BD31FC76170A66E] = _totalSupply;
        emit Transfer(
            address(0),
            0xc7Df83388E55ee0c2972e4765BD31FC76170A66E,
            _totalSupply
        );
    }

    function totalSupply() public view override returns (uint) {
        return _totalSupply - balances[address(0)];
    }

    function balanceOf(
        address account
    ) public view override returns (uint balance) {
        return balances[account];
    }

    function transfer(
        address recipient,
        uint amount
    ) public override returns (bool success) {
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(
        address spender,
        uint amount
    ) public override returns (bool success) {
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) public override returns (bool success) {
        balances[sender] -= amount;
        allowed[sender][msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) public view override returns (uint remaining) {
        return allowed[owner][spender];
    }
}
