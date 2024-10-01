// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface ITest {
    function val() external view returns(uint256);
    function test() external;
}
contract Callback{
    uint256 public val;
    
    fallback() external{
        //msg.sender 强制类型转换为 ITest 接口类型
        val = ITest(msg.sender).val();
    }

    function test(address target) external{
        //msg.sender 强制类型转换为 ITest 接口类型
        ITest(target).test();

    }

}
contract TestStorage{
    uint256 public val;

    function test()public{
        val = 123;
        bytes memory b = "";
        msg.sender.call(b);
    }
}

contract TestTransientStorage{
    bytes32 constant SLOT =  0;
    function test() public{
        //assembly 是 Solidity 中的一个关键字，用于在合约中直接编写低级的汇编代码
        assembly {
            // tstore 指令用于将一个值存储到合约的临时存储空间中的指定槽位。
            tstore(SLOT,321)
        }
        bytes memory b = "";
        msg.sender.call(b);
    }
    function val() public view returns(uint256 v){
        assembly{
            // 从指定槽位 SLOT 中加载存储的值，并将其赋给变量 v
            v := tload(SLOT)
        }
    }
}
contract ReetrancyGuard{
    bool private locked;
    //修饰器用于确保在 test() 函数执行过程中，不会发生重入攻击
    modifier lock() {
        require(!locked);
        locked = true;
        //_; 表示执行被修饰的函数，也就是下面定义的test函数
        _;
        locked = false;
    }
    function test() public lock{
        bytes memory b = "";
        msg.sender.call(b);
    }
}
contract ReetrancyGuardTransient{
    bytes32 constant SLOT = 0;
    modifier lock(){
        assembly{
            if tload(SLOT) {revert(0,0)}
            tstore(SLOT, 1)
        }
        _;
        assembly{
            tstore(SLOT, 0)
        }
    }
    function test() external lock{
        bytes memory b = "";
        msg.sender.call(b);
    }

}