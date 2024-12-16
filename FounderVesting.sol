// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract FounderVesting {
    address public founder;
    uint256 public start;
    uint256 public totalTokens;
    uint256 public releasedTokens;

    constructor(address _founder, uint256 _totalTokens) {
        founder = _founder;
        totalTokens = _totalTokens;
        start = block.timestamp;
    }

    function release() public {
        require(msg.sender == founder, "Not authorized");
        uint256 unlockable = getUnlockableTokens();
        require(unlockable > 0, "No tokens to release");

        releasedTokens += unlockable;
        payable(founder).transfer(unlockable);
    }

    function getUnlockableTokens() public view returns (uint256) {
        uint256 elapsed = block.timestamp - start;
        uint256 totalUnlocked = (totalTokens * elapsed) / (12 * 30 days); // 12-month vesting
        return totalUnlocked - releasedTokens;
    }
}
