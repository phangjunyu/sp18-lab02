pragma solidity ^0.4.0;

contract Greet {

    string greeting;

    function Greet (string _greeting) public {
        bytes memory a;
        greeting = _greeting;
    }

    function greeter() public constant returns (string) {
        return greeting;
    }
}
