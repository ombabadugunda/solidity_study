// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

contract Banker {
    
    mapping(address => uint) public loans;
    address public owner;

    constructor() {
        owner = msg.sender;
    }
    
    event LendEvent(address client, uint value, uint timestamp);

    function lend(uint amount) public {
        address client = msg.sender;
        loans[client] += amount;
    }

    function payback(uint amount, address client) public {
        require(msg.sender == owner, "Only owner can assign payback");
        loans[client] -= amount;
    }
}
