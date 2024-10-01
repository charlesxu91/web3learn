// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract X{
    string public name;

    constructor(string memory _name){
        name = _name;
    }

}
contract Y{
    string public text;
    constructor(string memory _text){
        text = _text;
    }
}

//B 继承了上面两个基础合约
contract B is X("Input to X"), Y("Input to Y"){}

//C 继承了上面两个基础合约，并定义了有参构造器
contract C is X,Y{
    constructor(string memory _name, string memory _text) X(_name) Y(_text){

    }

}

// 构造器的执行顺序 X，Y，D
//C 继承了上面两个基础合约，并设置了基础合约的初始值
contract D is X,Y{
    constructor() X("X was called") Y("Y was called"){

    }
}

// 构造器的执行顺序 X，Y，E
contract E is X,Y{
    constructor() Y("Y was called") X("X was called"){

    }
}