// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {MyToken} from "../src/MyToken.sol";

contract MyTokenTest is Test {
    MyToken public token; //被测试的合约实例

    //setup函数，每个测试前要执行
    function setUp() public {
        token = new MyToken(); //部署合约
    }

    //基本信息测试
    //public变量自动生成getter函数，要获取一个值，要从函数中调用，要用()
    function test_TokenInfo() public {
        //检查名字
        assertEq(token.name(), "Colin");

        //检查符号
        assertEq(token.symbol(), "COL");

        //检查小数位
        assertEq(token.decimals(), 18);
    }

    //测试用户持有代币
    function test_DeployerBalance() public {
        //测试合约中,this就是部署者
        assertEq(token.balances(address(this)), token.totalSupply());
    }

    //转账功能测试
    function test_transfer() public {
        address recipient = vm.addr(1); //从私钥生成一个测试地址
        uint256 amount = 1000 * 10 ** 18; //定义转账金额

        //记录转帐前金额
        uint256 senderBalanceBefore = token.balances(address(this));
        uint256 recipientBalanceBefore = token.balances(recipient);

        //执行转账
        bool success = token.transfer(recipient, amount);
        assertTrue(success); //验证转账成功返回true

        //发送方余额减少
        assertEq(token.balances(address(this)), senderBalanceBefore - amount);
        //接收方余额增加
        assertEq(token.balances(recipient), recipientBalanceBefore + amount);
    }
}
