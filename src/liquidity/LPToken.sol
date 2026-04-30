// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {MyToken} from "../MyToken.sol";

contract LPToken is MyToken {
    address public liquidityPool;

    event Mint(address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);

    modifier onlyLiquidityPool() {
        require(msg.sender == liquidityPool, "Not liquidity pool");
        _;
    }

    constructor(address _liquidityPool) {
        name = "LPToken";
        symbol = "LPT";
        totalSupply = 0;
        balances[msg.sender] = 0;
        liquidityPool = _liquidityPool;
    }

    function mint(address to, uint256 amount) 
        public 
        override 
        onlyLiquidityPool 
        whenNotPaused 
        nonReentrant 
        notBlacklisted(to) 
        returns (bool) 
    {
        balances[to] += amount;
        totalSupply += amount;
        emit Mint(to, amount);
        emit Transfer(address(0), to, amount);
        return true;
    }

    function burn(address from, uint256 amount) 
        public 
        onlyLiquidityPool 
        whenNotPaused 
        nonReentrant 
        notBlacklisted(from) 
        returns (bool) 
    {
        require(balances[from] >= amount, "Insufficient balance");
        balances[from] -= amount;
        totalSupply -= amount;
        emit Burn(from, amount);
        emit Transfer(from, address(0), amount);
        return true;
    }
}
