//mock
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
//for vm key word we need to use is script

contract HelperConfig is Script{
    NetworkConfig public  activeNetworkConfig;

    struct NetworkConfig {
        address priceFeed;
    }
    uint8 public constant   Decimals=8;
        int256 public constant initiL_PRICE=200E8;
       

    constructor(){
        if(block.chainid==11155111){
            activeNetworkConfig=gasSepoliaEthConfig();

        }else{
            activeNetworkConfig=getAnvilEthConfig();
        }
    }
    function gasSepoliaEthConfig() public pure returns(NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig=NetworkConfig({
            priceFeed:0x0F6A57458bD9461591bB61244217a0974aB28bb5
            });
            return sepoliaConfig;

    }
    function getAnvilEthConfig() public returns (NetworkConfig memory) {
    if (activeNetworkConfig.priceFeed != address(0)) {
        return activeNetworkConfig;
    }

    vm.startBroadcast();
    MockV3Aggregator mockPriceFeed =
        new MockV3Aggregator(Decimals, initiL_PRICE);
    vm.stopBroadcast();

    NetworkConfig memory anvilConfig = NetworkConfig({
        priceFeed: address(mockPriceFeed)
    });

    activeNetworkConfig = anvilConfig; // cache it
    return anvilConfig;
}

    

    
}