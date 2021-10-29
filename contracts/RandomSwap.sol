// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @custom:security-contact m@matthieuscarset.com
contract RandomSwap is Ownable {
    // Allow arbritrary closing of the app.
    bool public _lock;

    // List of last swaps' timestamps.
    mapping(address => uint256) private swaps;

    // Events.
    event Swap(address indexed _from, string _token, uint256 _amount);

    // Modifiers.
    modifier hasNotSwapToday() {
        require(
            block.timestamp >= (swaps[msg.sender] + 1 days),
            "No more swap for you today"
        );
        _;
    }

    // Deploy contract.
    constructor() {}

    // Make it swap!
    function swap(string memory _token, uint256 _amount)
        public
        payable
        hasNotSwapToday
    {
        // Security check.
        require(!_lock, "RandomSwap is closed at the moment");

        // Check solvability.
        if (msg.sender.balance < _amount) {
            revert("Sorry not enought money, honey");
        }

        // @todo Randomly select a token.

        // @todo Make it swap now.

        // Lock swapper for today.
        swaps[msg.sender] = block.timestamp;

        // Tell the world about this swap.
        emit Swap(msg.sender, _token, _amount);
    }
}
