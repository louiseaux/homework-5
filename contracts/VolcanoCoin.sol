// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts@4.2.0/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.2.0/access/Ownable.sol";

contract VolcanoCoin is ERC20, Ownable {
    
    uint public _totalSupply;
    
    event Supply_increase(uint);
    
    mapping(address => Payment[]) public payments;
    
    struct Payment {
        address recipient;
        uint amount;
    }
    
    constructor() ERC20("VolcanoCoin", "VOL") {
        _totalSupply = 10000;
        _mint(_msgSender(), _totalSupply);
    }
    
    function transfer(address _recipient, uint256 _amount) public override returns(bool) {
        _transfer(_msgSender(), _recipient, _amount);
        newPayment(_msgSender(), _recipient, _amount);
        return true;
    }
    
    function newPayment(address _sender, address _recipient, uint _amount) public {
        require(_sender == _msgSender());
        
        Payment memory payment;
        payment.recipient = _recipient;
        payment.amount = _amount;
        
        payments[_msgSender()].push(payment);
    }
    
    function getPayments(address user) public view returns (Payment[] memory) {
        return payments[user];
    }
    
    function changeOwnerSupply(uint _amount) public onlyOwner {
        _totalSupply += _amount;
        emit Supply_increase(_amount);
        
        _mint(_msgSender(), _amount);
    }
}