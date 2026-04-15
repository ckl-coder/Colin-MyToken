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

    //余额不足转账失败测试
    function test_TransferInsufficientBalance() public {
        address recipient = vm.addr(2);
        uint256 excessiveAmount = token.totalSupply() + 1;
        vm.expectRevert("Insufficient balance");
        token.transfer(recipient, excessiveAmount);
    }

    //授权转账测试
    function test_ApproveAndTransferFrom() public {
        address spender = vm.addr(3);
        address recipient = vm.addr(4);

        //设置授权金额
        uint256 amount = 1000 * 10 ** 18;
        //设置转账金额
        uint256 transferAmount = 500 * 10 ** 18;

        //记录授权帐前余额
        uint256 deployerBalanceBefore = token.balances(address(this));
        uint256 recipientBalanceBefore = token.balances(recipient);

        token.approve(spender, amount);
        vm.prank(spender);
        token.transferFrom(address(this), recipient, transferAmount);
        assertEq(token.allowance(address(this), spender), amount - transferAmount);
        assertEq(token.balances(recipient), recipientBalanceBefore + transferAmount);
        assertEq(token.balances(address(this)), deployerBalanceBefore - transferAmount);
    }

    //铸造测试
    function test_Mint() public {
        uint256 mintAmount = 1000 * 10 ** 18;
        address recipient = vm.addr(5);
        uint256 totalSupplyBefore = token.totalSupply();
        uint256 recipientBalanceBefore = token.balances(recipient);
        bool success = token.mint(recipient, mintAmount);
        assertTrue(success);
        assertEq(totalSupplyBefore + mintAmount, token.totalSupply());
        assertEq(token.balances(recipient), recipientBalanceBefore + mintAmount);
    }

    //销毁测试
    function test_Burn() public {
        uint256 totalSupplyBefore = token.totalSupply();
        uint256 burnAmount = 500 * 10 ** 18;
        uint256 BalanceBeforeBurn = token.balances(address(this));
        bool success = token.burn(burnAmount);
        assertTrue(success);
        assertEq(token.balances(address(this)), BalanceBeforeBurn - burnAmount);
        assertEq(totalSupplyBefore - burnAmount, token.totalSupply());
    }

    //测试非owner无法铸造
    function test_MintNotOwner() public {
        uint256 mintAmount = 1000 * 10 ** 18;
        address notOwner = vm.addr(6);
        vm.prank(notOwner);
        vm.expectRevert("Not owner");
        token.mint(notOwner, mintAmount);
    }
}
