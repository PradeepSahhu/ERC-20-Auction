// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract ERC20Auction is ERC20 {


    modifier onlyOwner{
        require(msg.sender == owner,"you are not owner");
        _;
    }

    uint256 private totalSupplyTokens;
    uint256 private eachTokenPrice;
    address private owner;
    address private lastHighestOwner;
    uint private lastHighest;
    address private lastHighestSellOwner;
    uint private lastHighestSell;


    constructor(uint256 _initialAmount) ERC20("UniCoin", "UCN") {
        _mint(msg.sender, _initialAmount);
        totalSupplyTokens = _initialAmount;
        eachTokenPrice = 100; // Price per token in wei
        owner = msg.sender;
    }

    function withdraw() public payable{
        (bool msgCall,) = payable(owner).call{value:address(this).balance}("");
        require(msgCall, "Cant full filled");
    }


    function InstantBuy(uint TokenCount) public payable {

       uint totalWei =  TokenCount * eachTokenPrice;
       require(msg.value >= totalWei, "Not enough Wei");
       _transfer(owner,msg.sender,TokenCount);
     
    }


    function InstantSell(uint TokenCount) public payable{
       uint totalWei =  TokenCount * eachTokenPrice;
       _transfer(msg.sender, owner, TokenCount);
       require(address(this).balance >= totalWei,"Not enough Wei in the Account");
       (bool callmsg, ) = payable(msg.sender).call{value: totalWei}("");
       require(callmsg, "Can't transfer the amount");
    }


    function auctionBuy() public payable{
        if(msg.value > lastHighest){
            (bool callmsg, ) = payable(lastHighestOwner).call{value:lastHighest}("");
            require(callmsg,"Can't Transfered");
            lastHighest = msg.value;
        }
        lastHighestOwner = msg.sender;
    }

    function finishAuctionBuy() public payable onlyOwner{
        _transfer(owner, lastHighestOwner, 1);
        lastHighest = 0;
        lastHighestOwner = address(0);
    }


    function burnToken(uint256 _burnAmount ) external{
        require(balanceOf(msg.sender) >= _burnAmount);
        _burn(msg.sender,_burnAmount);
      
    }




}
