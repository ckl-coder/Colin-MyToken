// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Pausable {
    //状态变量
    bool private _paused;

    //添加事件(events)
    event Paused(address indexed account);
    event Unpaused(address indexed account);

    constructor() {
        _paused = false;
    }
    //合约未暂停才能执行
    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }
    //合约已暂停才能执行
    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }

    function paused() public view returns (bool) {
        return _paused;
    }

    // 内部函数，不设置权限修饰符
    //只有合约未暂停才能运行
    function _pause() internal whenNotPaused {
        _paused = true;
        emit Paused(msg.sender);
    }
    //只有合约已暂停才能运行
    function _unpause() internal whenPaused {
        _paused = false;
        emit Unpaused(msg.sender);
    }
}
