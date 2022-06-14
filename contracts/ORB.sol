//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract ORB is Initializable, ERC20Upgradeable{
    function initialize() external initializer {
        __ERC20_init("MyCollectible", "MCO");
        _mint(msg.sender, 500000000 *(10 ** uint(decimals())));
    }
}
