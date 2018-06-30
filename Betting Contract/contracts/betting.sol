pragma solidity ^0.4.24;


contract Betting {
    /* Constructor function, where owner and outcomes are set */
    constructor(uint[] _outcomes) public {
        for (uint i = 0; i < _outcomes.length; i++){
            outcomes[i] = _outcomes[i];
        }
        owner = msg.sender;
    }

    /* Fallback function */
    function() public payable {
        revert();
    }

    /* Standard state variables */
    address public owner;
    address public gamblerA;
    address public gamblerB;
    address public oracle;

    /* Structs are custom data structures with self-defined parameters */
    struct Bet {
        uint outcome;
        uint amount;
        bool initialized;
    }

    /* Keep track of every gambler's bet */
    mapping (address => Bet) bets;
    /* Keep track of every player's winnings (if any) */
    mapping (address => uint) winnings;
    /* Keep track of all outcomes (maps index to numerical outcome) */
    mapping (uint => uint) public outcomes;

    /* Add any events you think are necessary */
    event BetMade(address gambler);
    event BetClosed();

    /* Uh Oh, what are these? */
    modifier ownerOnly() {
        // assert(msg.sender == owner);
        if (msg.sender == owner)
        _;
    }
    modifier oracleOnly() {
        if (msg.sender == oracle)
        _;
    }
    modifier outcomeExists(uint outcome) {
        if (outcomes[outcome] != 0)
        _;
    }

    /* Owner chooses their trusted Oracle */
    function chooseOracle(address _oracle) public ownerOnly() returns (address) {
        oracle = _oracle;
        return oracle;
    }

    /* Gamblers place their bets, preferably after calling checkOutcomes */
    function makeBet(uint _outcome) public payable returns (bool) {
        address gambler = msg.sender;

        //condition
        require(gambler != oracle && gambler != owner);
        require(!bets[gambler].initialized);

        //effect
        bets[gambler].outcome = _outcome;
        bets[gambler].amount = msg.value;
        bets[gambler].initialized = true;
        emit BetMade(gambler);

        if (!bets[gamblerA].initialized)
            gamblerA = gambler;
        else{
            gamblerB = gambler;
            emit BetClosed();
        }


        return bets[gambler].initialized;
    }

    /* The oracle chooses which outcome wins */
    function makeDecision(uint _outcome) public oracleOnly() outcomeExists(_outcome) {
        require(bets[gamblerA].initialized && bets[gamblerB].initialized);
        bets[oracle].outcome = _outcome;
        uint amtA = bets[gamblerA].amount;
        uint amtB = bets[gamblerB].amount;

        if (bets[gamblerA].outcome == bets[gamblerB].outcome){
            gamblerA.transfer(amtA);
            gamblerB.transfer(amtB);
        } else {
            if (bets[gamblerA].outcome == outcomes[_outcome]){
                if (bets[gamblerB].outcome == outcomes[_outcome]){
                    winnings[gamblerA] = amtA;
                    winnings[gamblerB] = amtB;
                } else {
                    winnings[gamblerA] = amtA + amtB;
                }
            } else {
                if (bets[gamblerB].outcome == outcomes[_outcome]){
                    winnings[gamblerB] = amtA + amtB;
                } else {
                    winnings[oracle] = amtA + amtB;
                }
            }
        }
    }

    /* Allow anyone to withdraw their winnings safely (if they have enough) */
    function withdraw(uint withdrawAmount) public returns (uint) {
        require(winnings[msg.sender] > withdrawAmount);
        msg.sender.transfer(withdrawAmount);
        winnings[msg.sender] =- withdrawAmount;
        return winnings[msg.sender];
    }

    /* Allow anyone to check the outcomes they can bet on */
    function checkOutcomes(uint outcome) public view returns (uint) {
        return outcomes[outcome];
    }

    /* Allow anyone to check if they won any bets */
    function checkWinnings() public view returns(uint) {
        return winnings[msg.sender];
    }

    /* Call delete() to reset certain state variables. Which ones? That's upto you to decide */
    function contractReset() public ownerOnly() {

        delete bets[oracle];
        delete bets[gamblerA];
        delete bets[gamblerB];
    }
}
