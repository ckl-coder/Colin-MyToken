// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Pausable} from "./security/Pausable.sol";
import {Blacklist} from "./security/Blacklist.sol";
import {ReentrancyGuard} from "./security/ReentrancyGuard.sol";

contract MyToken is Pausable, Blacklist, ReentrancyGuard {
    string public name;
    string public symbol;
    uint8 public decimals; //八位足够，过多会浪费存储空间，Gas费高
    uint256 public totalSupply;
    address public owner;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowance;
    //    授权者地址  =>       (被授权者地址 => 授权金额)
    //       allowance[授权者][被授权者] = 授权金额

    //添加事件(events)
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    //只有Owner才能执行
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }


    constructor() {
        name = "Colin";
        symbol = "COL";
        decimals = 18;
        totalSupply = 100000 * (10 ** decimals); //100万总供应量
        balances[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    //转账（从msg.sender转向用户）
    function transfer(address to, uint256 amount) public whenNotPaused notBlacklisted(msg.sender) nonReentrant returns (bool) {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    //授权
    //给某个地址授权一定的额度
    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    //授权转账(transferFrom)
    //被授权的人帮你转账
    function transferFrom(address from, address to, uint256 amount) public whenNotPaused notBlacklisted(from) nonReentrant returns (bool) {
        require(balances[from] >= amount, "Insufficient balance for transfer");
        require(allowance[from][msg.sender] >= amount, "Insufficient allowance");
        balances[from] -= amount;
        balances[to] += amount;
        allowance[from][msg.sender] -= amount;
        emit Transfer(from, to, amount);
        return true;
    }

    //mint铸造
    function mint(address to, uint256 amount) public onlyOwner whenNotPaused nonReentrant returns (bool) {
        balances[to] += amount;
        totalSupply += amount;
        emit Transfer(address(0), to, amount);
        return true;
    }

    //burn销毁
    function burn(uint256 amount) public whenNotPaused nonReentrant returns (bool) {
        require(balances[msg.sender] >= amount, "Insufficient amount");
        balances[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
        return true;
    }

    //包装函数：添加权限控制
    function pause() public onlyOwner {
        _pause();  // 调用父合约的内部函数
    }
    
    function unpause() public onlyOwner {
        _unpause();
    }

    //包装函数：黑名单管理
    function addToBlacklist(address account) public onlyOwner {
        _addToBlacklist(account);
    }

    function removeBlacklist(address account) public onlyOwner {
        _removeFromBlacklist(account);
    }
}
