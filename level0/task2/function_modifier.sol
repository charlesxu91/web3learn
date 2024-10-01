// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract FunctionModifier{
    address public owner;
    uint256 public x = 10;
    bool public locked;

    constructor(){
        owner = msg.sender;
    }
    //
    modifier onlyOwner(){
        require(msg.sender == owner, "not owner");
        _;
    }

    modifier validAddress(address _addr){
        require(_addr != address(0), "not valid address");
        _;
    }

    function changeOwner(address _newOwner) public onlyOwner validAddress(_newOwner){
        owner = _newOwner;
    }
    //
    modifier noReentrancy(){
        require(!locked, "no reentrancy");
        locked = true;
        _;
        locked= false;
    }
    function decrement(uint256 i ) public noReentrancy{
        x-=i;
        if(i > 1){
            decrement(i-1);
        }
    }
}