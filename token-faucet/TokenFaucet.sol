// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MyToken.sol";

contract TokenFaucet {
    MyToken public token;
    address public owner;
    uint256 public dripAmount;

    event TokensDripped(address indexed recipient, uint256 amount);

    constructor(address _tokenAddress, uint256 _dripAmount) {
        token = MyToken(_tokenAddress);
        owner = msg.sender;
        dripAmount = _dripAmount;
    }

    function dripTokens() public {
        require(msg.sender == owner, "Only the owner can drip tokens");
        require(token.balanceOf(address(this)) >= dripAmount, "Insufficient balance in the faucet");

        token.transfer(msg.sender, dripAmount);
        emit TokensDripped(msg.sender, dripAmount);
    }
}
