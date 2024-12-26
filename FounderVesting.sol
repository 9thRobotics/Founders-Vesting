// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FounderVesting {
    using SafeMath for uint256;

    address public founder;
    uint256 public start;
    uint256 public totalTokens;
    uint256 public releasedTokens;
    IERC20 public token;

    event TokensReleased(uint256 amount);

    constructor(address _founder, uint256 _totalTokens, address _token) {
        require(_founder != address(0), "Founder address cannot be zero");
        founder = _founder;
        totalTokens = _totalTokens;
        token = IERC20(_token);
        start = block.timestamp;
    }

    function release() public {
        require(msg.sender == founder, "Not authorized");
        uint256 unlockable = getUnlockableTokens();
        require(unlockable > 0, "No tokens to release");

        releasedTokens = releasedTokens.add(unlockable);
        require(token.transfer(founder, unlockable), "Token transfer failed");

        emit TokensReleased(unlockable);
    }

    function getUnlockableTokens() public view returns (uint256) {
        uint256 elapsed = block.timestamp.sub(start);
        uint256 totalUnlocked = totalTokens.mul(elapsed).div(12 * 30 days); // 12-month vesting
        return totalUnlocked.sub(releasedTokens);
    }
}
