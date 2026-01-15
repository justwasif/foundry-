// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {

    function run() external returns (FundMe) {
        //this help config is before dbordcast so no real transction only inside vm tranction occure
        HelperConfig helperCOnfig=new HelperConfig();
        address ethUsdPriceFeed=helperCOnfig.activeNetworkConfig();
        vm.startBroadcast();
        //Mock
        FundMe fundme=new FundMe(0x0F6A57458bD9461591bB61244217a0974aB28bb5);
        vm.stopBroadcast();
        return fundme;
    }
}
