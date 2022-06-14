//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

contract ORBv2 is ERC20Upgradeable{
    // function initialize() initializer public {
    //     __ERC20_init("MyCollectible", "MCO");        
    //     _mint(msg.sender, 500000000 *(10 ** uint(decimals())));
    // }

    function getNumber() public pure returns(uint256 number){
        return 5;
    }
}
