pragma solidity >0.8.4;

contract RockPaperScissors {
    address payable owner;
    address payable playerTwo;

    mapping(address => bytes32) commitments;
    mapping(address => bool) isPlaced;
    uint bet;

    mapping(address => uint) revealedCommitments;
    mapping(address => bool) isRevealed;

    mapping(uint => mapping(uint => uint)) private gameResults;

    // restricts access to players only
    modifier onlyPlayer() {
        require (msg.sender == owner || msg.sender == playerTwo);
        _;
    }

    // 0, 1, 2 are rock, paper, scissors
    constructor (address _playerTwo) {
        owner = payable(msg.sender);
        playerTwo = payable(_playerTwo);

        gameResults[0][0] = 0;
        gameResults[1][1] = 0;
        gameResults[2][2] = 0;
        gameResults[0][1] = 2;
        gameResults[1][2] = 2;
        gameResults[2][0] = 2;
        gameResults[0][2] = 1;
        gameResults[1][0] = 1;
        gameResults[2][1] = 1;
    }

    // allows to commit to one choice per game and processes the bet
    function commit(bytes32 _hashedChoice) public payable onlyPlayer {
        if (address(this).balance > 0) {
            require (msg.value == address(this).balance);
        }
        commitments[msg.sender] = _hashedChoice;
        isPlaced[msg.sender] = true;
    }

    // allows players to reveal their commitment and checks that it is correctly revealed
    function reveal(uint _choice, int _nonce) public onlyPlayer {
        require(isPlaced[owner]);
        require(isPlaced[playerTwo]);
        require(isRevealed[msg.sender] == false);

        _choice = _choice % 3;
        bytes32 claimHash = keccak256(abi.encodePacked(_choice, _nonce));

        require (claimHash == commitments[msg.sender]);
        revealedCommitments[msg.sender] = _choice;
        isRevealed[msg.sender] = true;
    }

    // at the end of the game, this method pays the winner
    function distributeWinnings() public onlyPlayer {
        require (isRevealed[owner] && isRevealed[playerTwo]);
        uint result = gameResults[revealedCommitments[owner]][revealedCommitments[playerTwo]];
        if(result == 0){
            owner.transfer(bet);
            playerTwo.transfer(bet);
        } else if(result == 1){
            owner.transfer(2*bet);
        }else{
            playerTwo.transfer(2*bet);
        }
        isPlaced[owner]=false;
        isPlaced[playerTwo]=false;
        bet = 0;
        isRevealed[owner]=false;
        isRevealed[playerTwo]=false;
    }
}