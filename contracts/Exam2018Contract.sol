pragma solidity ^0.8.0;

contract SalaryContract {
    mapping (address => uint) balances;
    
    function deposit() public payable {
        require(msg.value > 2 ether);
        balances[msg.sender] += uint(msg.value);
    }

    function checkPayment(address from) view public returns (bool) {
        return balances[from] > 0;
    }
}