// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol" ;
import {Test,console} from "forge-std/Test.sol";


contract FundMeTest is Test{
    FundMe fundme;
    function setUp() external{
        //fundme =new FundMe(0x0F6A57458bD9461591bB61244217a0974aB28bb5);
        DeployFundMe deployFundMe=new DeployFundMe();
        fundme=deployFundMe.run();
        

    }
    function testMinIsFive() public{
        
        console.log("this is",fundme.MINIMUM_USD());

    }
    function testOwnerSender() public{
        console.log("this is",fundme.i_owner());
        console.log(msg.sender);
        assertEq(fundme.i_owner(),msg.sender);
    
    }
    
    


}