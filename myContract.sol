// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract myContract {
    string public myString = "My String";
    bool public boolean1 = true;
    uint public myUint = 1;
    int public myInt = 1;
    address public myAddress = 0x52bc44d5378309EE2abF1539BF71dE1b7d7bE3b5;
}

contract myFunction {
    string name = "Example 1";

    function setName(string memory _name) public {
        name = _name;
    }

    function getName() public view returns(string memory) {
        return name;
    }

    function resetName()  public {
        name = "Example 1";
    }
}

contract myVisibility {
    string name1 = "name1";
    string private name2 = "name2";
    string internal name3 = "name3";
    string public name4 = "name4";
}

contract myCount {
    uint public count;

    function increment1() public{
        count = count+1
    }
}

contract myModifiers{
    string public name = "Example 5";
    uint public balance;

    function getName() public view returns(string memory){
        return name;
    }

    function add(uint a,uint b) public pure returns(uint){
        return a+b;
    } 

    function pay() public payable{
        balance = msg.value;
    }

}

contract myConstructor{
    string public name;

    constructor(string memory _name){
        name = _name
    }
}

contract myMappings{
    mapping(uint => string) public names;
    mapping(uint => address) public addresses;
    mapping(uint => uint) public balances;
    mapping(uint => bool) public hasVoted;
    mapping(uint => mapping(uint => bool)) public myMapping;
}

