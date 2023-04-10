// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract Fundme{
    mapping(address => uint256) public addressToAmountFunded;
    address payable owner;
    address[] funders;

    constructor(){
        owner = payable(msg.sender);
    }
                   
    modifier OnlyOwner(){
        require(msg.sender == owner, "You do not have access to this action");
        _;
    }

    function fund() public payable {
        uint256 minValue = 50 * 10 ** 18; // Minimum value of 50$
        require(getConversionRateint(msg.value) >= minValue, "Spend more ETH");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getversion() public view returns(uint256){
        AggregatorV3Interface pricefeedVer = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306); //ETH-USD Sepolia TestNet Address
        return pricefeedVer.version();
    }

    function getPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306); //ETH-USD Sepolia TestNet Address
        (, int256 answer , , ,) = priceFeed.latestRoundData();
         return uint256(answer * 10000000000);
    }

    function getConversionRateint(uint256 ethAmount) public view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;
    }

    function withdrawFund() payable OnlyOwner public {
        payable(msg.sender).transfer(address(this).balance);

        for(uint256 fundersIndex = 0; fundersIndex < funders.length; fundersIndex++){
            address funder = funders[fundersIndex];
            addressToAmountFunded[funder] = 0;
        }
    }
    

}