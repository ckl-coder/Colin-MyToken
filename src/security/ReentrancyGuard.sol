// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ReentrancyGuard {
    uint256 private constant NotEntered = 1;
    uint256 private constant Entered = 2;

    uint256 private _status ;

    error ReentrantGuardReentrantCall();

    constructor(){
        _status = NotEntered;
    }

    modifier nonReentrant(){
        // 重入保护状态为 NotEntered 才时，才能进入重入保护状态
        //若要降低gas消耗，可以使用revert＋自定义error
        //if (_status == Entered){
        // revert ReentrantGuardReentrantCall();
        //}
        require(_status == NotEntered, "ReentrantGuardReentrantCall");
        // 进入重入保护状态
        _status = Entered;
        _;
        _status = NotEntered;
    }
}
