// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol" ;
import {Test,console} from "forge-std/Test.sol";


contract FundMeTest is Test{
    FundMe fundme;
    address USER=makeAddr("user");
    uint256 constant send_val=0.1 ether;
    uint256 constant Start_bal=10 ether;
    UINT256 constant GAS_PRICE=1;

    function setUp() external{
        //fundme =new FundMe(0x0F6A57458bD9461591bB61244217a0974aB28bb5);
        DeployFundMe deployFundMe=new DeployFundMe();
        fundme=deployFundMe.run();
        vm.deal(USER,Start_bal);
        

    }
    function testMinIsFive() public{
        
        console.log("this is",fundme.MINIMUM_USD());

    }
    function testOwnerSender() public{
        console.log("this is",fundme.i_owner());
        console.log(msg.sender);
        assertEq(fundme.i_owner(),msg.sender);
    
    }

    function testFailsWithoutEnoughETH() public{
        vm.expectRevert();
        fundme.fund();
    }
    function testUpdatesFundedDataStructure() public{
        vm.prank(USER);
        fundme.fund{value:send_val}();
        uint256 amountFunded=fundme.getAddressToAmountFunded(USER);
        assertEq(amountFunded,send_val);

       
    }

    function testAddsFunderToArrayOfFunders() public{
        vm.prank(USER);
        fundme.fund{value:send_val}();
        address funder =fundme.getFunder(0);
        assertEq(funder,USER);

    }

    modifier funded(){
        vm.prank(USER);
        fundme.fund{value:send_val}();
        _;
    }
    function testOnlyOwenrCanWithdraw() public funded{
        vm.prank(USER);
        vm.expectRevert();
        fundme.withdraw();
    }

    function testWithDrawWithASingleDunder() public funded{
        //log_array
        uint256 startingOwnerBalance=fundme.getOwner().balance;
        uint256 startingFundMeBalance=address(fundme).balance;
        vm.prank(fundme.getOwner());

        uint256 endingOwnerBalance=fundme.getOwner().balance;
        uint256 endingFundMeBalance=address(fundme).balance;
        console.log(endingOwnerBalance);
        assertEq(startingFundMeBalance+startingOwnerBalance,endingOwnerBalance);
        
    }
    function testWithdrawMultipleFunders() public funded{
        uint160 numberOfFunders=10;//if u want to generate address from number u have to use uint160
        uint160 startingFunderIndex=1;
        for(uint160 i=startingFunderIndex;i<numberOfFunders;i++){
            hoax(address(i),send_val);
            fundme.fund{value:send_val}();

        }
        uint256 startingOwnerBalnce=fundme.getOwner().balance;
        uint256 startingFunderBalance=address(fundme).balance;
        uint256 endingOwnerBalance=address(fundme).balance;
        uint265 gasStart=gasleft();
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner());
        fundme.withdraw();
        uint256 gasend=gasleft();
        uint256 gasUsed=(gasStart-gasend)*tx.gasprice;
        console.log(gasUsed);

        assertEq(address(fundme).balance,0);
        assertEq(startingFunderBalance+startingOwnerBalnce,endingOwnerBalance);
    }


    


}