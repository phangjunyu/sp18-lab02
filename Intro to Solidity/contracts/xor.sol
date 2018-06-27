pragma solidity ^0.4.0;

contract xor{
    function xor_func(uint a, uint b) public pure returns (uint){
        if (a==b){
            return 0;
        }
        else {
            return 1;
        }
    }
}
