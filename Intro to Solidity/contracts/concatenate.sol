// import "github.com/Arachnid/solidity-stringutils/strings.sol";

// contract C {
//   using strings for *;
//   string public s;

//   function foo(string s1, string s2) public view returns (string){
//     s = s1.toSlice().concat(s2.toSlice());
//     return s;
//   }
// }

pragma solidity ^0.4.0;

contract Concatenate{
    function concat(string a, string b) public view returns (string){
        bytes memory _a = bytes(a);
        bytes memory _b = bytes(b);
        string memory finalstr = new string(_a.length + _b.length);
        bytes memory finalbytes = bytes(finalstr);
        for(uint i = 0; i < _a.length; i++){
            finalbytes[i] = _a[i];
        }
        for(i = 0; i < _b.length; i++){
            finalbytes[i+_a.length] = _b[i];
        }
        return string(finalbytes);
    }
}
