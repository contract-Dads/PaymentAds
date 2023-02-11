// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./Advertiser.sol";

contract ManagerContract is Ownable , ReentrancyGuard {
    using SafeERC20 for IERC20; 
    using SafeMath for uint256;

    struct AdViewer {
        address viewer;
        uint256 balance;
    }

    
    mapping(address => address) public Advertisers;
    mapping(address => AdViewer) public AdViewers;
    IERC20 private token;
    uint256 rateSwap;

    constructor () {
        
    }

    function setRateSwap(uint256 rate) onlyOwner public {
        rateSwap = rate;
    }

    function setToken(address _token) onlyOwner public {
        token = IERC20(_token);
    }

    function createAdvertiser(address _advertiser, address _token) public 
    {
        Advertiser advertiserContract = new Advertiser(
            _advertiser,
            _token,
            address(this)
        );
        address advertiserContractAddress = address(advertiserContract);
        Advertisers[_advertiser] = advertiserContractAddress;
    }

    function swaptoken(uint256 amount) onlyOwner public {

        uint256 balanceContract = token.balanceOf(address(this));
        require(balanceContract > amount, "not enough balance");
        uint256 value = amount.mul(rateSwap);
        token.safeTransfer(msg.sender, value);
    }

    function withdrawtoken(uint256 amount) onlyOwner public {
        token.safeTransfer(msg.sender, amount);
    }
}