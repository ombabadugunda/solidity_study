// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

contract Banker {
    
    mapping(address => uint) loans;
    address owner;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
    }

    function fillBalance() public payable {
        require(msg.sender == owner, "Only owner can perform this action");
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
        loans[client] = amount;
        if (_checkAccount(client, amount)) {
            client.transfer(amount);
        } else {
            revert();
        }
    }

    function payback() public payable{
        address payable client = payable(msg.sender);
        require(loans[client] > 0, "Nothing to payback");
        require(loans[client] >= msg.value, "Payback amount is bigger than your loan");
        loans[client] -= msg.value;
    }
}
