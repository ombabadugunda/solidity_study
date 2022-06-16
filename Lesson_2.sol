// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

contract Banker {
    
    mapping(address => uint) public loans;
    address public owner;

    constructor() payable {
        owner = msg.sender;
    }
    
    event PayEvent(address client, uint value, uint timestamp);
    event LendEvent(address client, uint value, uint timestamp);
    event PaybackEvent(address client, uint value, uint timestamp);

    receive() external payable {
        pay();
    }

    function pay() public payable {
        emit PayEvent(msg.sender, msg.value, block.number);
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }
   
    function lend(uint amount) public {
        require(getBalance() >= amount, "Contract doesn`t have enough money");
        address payable client = payable(msg.sender);
        loans[client] += amount;
        emit LendEvent(msg.sender, msg.value, block.number);
    }

    function payback() public payable{
        address payable client = payable(msg.sender);
        require(loans[client] > 0, "Nothing to payback");
        require(loans[client] >= msg.value, "Payback amount is bigger than your loan");
        loans[client] -= msg.value;
        emit PaybackEvent(msg.sender, msg.value, block.number);
    }
}
