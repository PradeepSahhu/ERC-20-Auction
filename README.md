# ERC-20 Auction

This Smart contract depicts the auction house model in which either we can instantly buy, instantly sell or buy or sell through auction. (auction sell didn't implemeted because it is similar to auction buy - in my opinion)

Here Tokens will be traded for some amount of wei in instant sell or buy. and in auction buy, Highest amount wei owner will get 1 token. (in short highest bidder will get 1 token)

Importing openzeppelin's ERC20 contract which provide a structure and some functionality to our contract.

```Solidity
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
```

Through import command i am importing it.


## Some Functionality

```Solidity

 constructor(uint256 _initialAmount) ERC20("UniCoin", "UCN") {
        _mint(msg.sender, _initialAmount);
        totalSupplyTokens = _initialAmount;
        eachTokenPrice = 100; // Price per token in wei
        owner = msg.sender;
    }
```

Naming my token ```UniCoin``` and its Symbol is  ```UCN``` with price 100 wei per token for instant buy and instant sell.

```Solidity
  function InstantBuy(uint TokenCount) public payable {

       uint totalWei =  TokenCount * eachTokenPrice;
       require(msg.value >= totalWei, "Not enough Wei");
       _transfer(owner,msg.sender,TokenCount);
     
    }
```

Instant Buy Function take no of tokens wants to buy checks the required wei for it and if it is enough then sends the token to the address using the transfer function of ERC-20.

```Solidity

 function InstantSell(uint TokenCount) public payable{
       uint totalWei =  TokenCount * eachTokenPrice;
       _transfer(msg.sender, owner, TokenCount);
       require(address(this).balance >= totalWei,"Not enough Wei in the Account");
       (bool callmsg, ) = payable(msg.sender).call{value: totalWei}("");
       require(callmsg, "Can't transfer the amount");
    }
```

similarly, Instant sell function take no of tokens wants to sell calculate the totalWei amount corresponding to it and transfer the token from the caller to the auction owner and takes the wei for it using lower level function _transfer.

```Solidity

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
```

These two functions are linked as auctionBuy function called by the bidder and their amount. the Address and amount of the highest bigger will be stored in the state variables and the previous highest bidder amount will be given back to him/her and new highest bidder address and amount will be stored here. when the owner will click the finishAuctionBuy function then the amount of token i.e. 1 will be given to the highest bidder.

burn Token function - It simply means sending the _amount of token to the ```address(0)``` as it is 0th address. and updating the totalSupply and currenct Account supply from the ERC-20 state variables.

```Solidity

 function burnToken(uint256 _burnAmount ) external{
        require(balanceOf(msg.sender) >= _burnAmount);
        _burn(msg.sender,_burnAmount);
      
    }
```

That's why use _burn lower level function to burn the token and update it to the totalSupply and current Account supply state variables.





