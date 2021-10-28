// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @custom:security-contact m@matthieuscarset.com
contract RandomSwap is ERC20, ERC20Burnable, Ownable {
    // List of swappers (e.g. balances).
    mapping(address => uint256) private swappers;

    // List of last swaps' timestamps.
    mapping(address => uint256) private swaps;

    // Events.
    event Deposit(address indexed _from, bytes32 indexed _id, uint256 _value);
    event Withdraw(address indexed _from, uint256 _value);
    event Swap(address indexed _from, uint256 _token0, uint256 _token1);

    // Deploy contract.
    constructor() ERC20("RandomSwap", "RSWAP") {
        console.log("Deploying RSWAP tokens (1000)");
        _mint(msg.sender, 1000 * 10**decimals());
    }

    // God user can create tokens.
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Hello money.
    function deposit(bytes32 _id) public payable {
        uint256 _amount = msg.value;
        uint256 _balance = swappers[msg.sender];
        swappers[msg.sender] = _balance + _amount;

        emit Deposit(msg.sender, _id, msg.value);
    }

    // Bye bye money.
    function withdraw(uint256 _amount) public {
        uint256 _balance = swappers[msg.sender];

        // Check if enought cash, send it and update balance.
        require(_balance >= _amount, "Not enough money");
        this.transfer(msg.sender, _amount);
        swappers[msg.sender] = _balance - _amount;

        emit Withdraw(msg.sender, _amount);
    }

    // Make it swap!
    function makeItSwap(uint256 _amount) public {
        uint256 _now = block.timestamp;
        uint256 _lastSwap = swaps[msg.sender];
        uint256 _balance = swappers[msg.sender];

        // No money, no honey.
        require(_balance > 0, "Empty balance");

        // Have you already swapped today?
        if (_lastSwap > 0) {
            require(
                _now >= (_lastSwap + 1 days),
                "No more swap for you today."
            );
        }

        // Enought cash?
        require(_balance >= _amount, "Not enough money");

        // @todo Prepare source and target token.
        uint256 _token0;
        uint256 _token1;

        // @todo Make it swap now.

        // Lock swapper for today.
        swaps[msg.sender] = _now;

        // @todo trigger event.
        emit Swap(msg.sender, _token0, _token1);
    }

    // Check one's balance.
    function getBalance(address _from) public view returns (uint256) {
        return swappers[_from];
    }
}
