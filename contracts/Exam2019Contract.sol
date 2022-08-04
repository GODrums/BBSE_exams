pragma solidity ^0.8.0;

contract Lottery {
    address owner;
    uint pot;
    address[] players;
    address winner;

    modifier onlyOwner {
        require (msg.sender == owner);
        _;
    }

    constructor() public {
        owner = msg.sender;
        pot = uint(0);
        winner = address(0);
    }

    function payIn() public payable {
        require(msg.value >= 1 ether);
        pot += msg.value;
        players.push(msg.sender);
    }

    function selectWinner() public onlyOwner {
        require(winner == address(0));
        uint random = uint(blockhash(block.number)) % players.length;
        winner = players[random];
    }

    function withdraw() public {
        require(msg.sender == winner);
        uint winning = pot;
        pot = 0;
        payable(winner).transfer(winning);
    }
}