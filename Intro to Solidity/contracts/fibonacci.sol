pragma solidity ^0.4.0;

contract Fibonacci{

    function fibRecur(uint n) public pure returns (uint){
        if (n== 0) return 0;
        if (n== 1) return 1;
        else return fibRecur(n-1) + fibRecur(n-2);
    }

}
