// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

contract Banker {
    
    mapping(address => uint) public loans;
    address public owner;

    constructor() payable {
        owner = msg.sender;
    }
    
    event Event(address client);

    receive() external payable {
        pay();
    }

    function pay() public payable {
        emit Event(msg.sender);
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    
    function _checkAccount(address client, uint amount) internal view returns(bool) {
        return (loans[client] == amount);
    }

    function lend(uint amount) public {
        require(getBalance() >= amount, "Contract doesn`t have enough money");
        address payable client = payable(msg.sender);
        loans[client] += amount;
    }

    function payback() public payable{
        address payable client = payable(msg.sender);
        require(loans[client] > 0, "Nothing to payback");
        require(loans[client] >= msg.value, "Payback amount is bigger than your loan");
        loans[client] -= msg.value;
    }
}
