// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts@4.2.0/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.2.0/access/Ownable.sol";

contract VolcanoCoin is ERC20, Ownable {
    
    uint _totalSupply = 10000;
    
    event Supply_increase(uint);
    event Transfer(address indexed, uint);
    
    mapping(address => Payment[]) payments;
    
    struct Payment {
        address recipient;
        uint amount;
    }
    
    constructor() ERC20("VolcanoCoin", "VOL") {
        _mint(msg.sender, _totalSupply);
    }
    
    function transferTo(address _recipient, uint _amount) public {
        require(_amount > 0, "Amount must be > 0");
        
        transfer(_recipient, _amount);
        emit Transfer(_recipient, _amount);
        
        Payment memory payment;
        payment.recipient = _recipient;
        payment.amount = _amount;
        
        payments[msg.sender].push(payment);
    }
    
    function getPayments(address user) public view returns (Payment[] memory) {
        return payments[user];
    }
    
    function changeOwnerSupply(uint _amount) public onlyOwner {
        _totalSupply += _amount;
        emit Supply_increase(_amount);
        
        _mint(msg.sender, _amount);
    }
}