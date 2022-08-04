pragma solidity ^0.8.0;

contract Auction {

    address payable owner;

    struct item {
        string item_name;
        uint price;
        address payable highest_bidder;
    }

    item public auctioned_item;

    mapping (address => uint) public accountBalances;

    modifier onlyOwner {
        require (msg.sender == owner);
        _;
    }

    constructor () public {
        owner = payable(msg.sender);
    }

    function setAuctionedItem(string memory _item, uint _price) public onlyOwner {
        auctioned_item = item(_item, _price, payable(address(0)));
    }

    function bid() public payable {
        require (msg.value > auctioned_item.price);

        accountBalances[auctioned_item.highest_bidder] += auctioned_item.price;
        auctioned_item.price = msg.value;
        auctioned_item.highest_bidder = payable(msg.sender);
    }

    function withdraw() public {
        require (accountBalances[msg.sender] > 0);

        uint balance = accountBalances[msg.sender];
        accountBalances[msg.sender] = 0;

        payable(msg.sender).transfer(balance);
    }

    function finishAuction() public onlyOwner {
        owner.transfer(auctioned_item.price);
    }
}