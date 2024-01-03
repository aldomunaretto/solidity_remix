// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

contract SimpleStorage{
    uint256 favoriteNumber;

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    mapping(string => uint256) public nameToFavoriteNumber;

    People[] public people;

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }

    // view
    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }

    //pure
    function pureFunction(uint256 _number) public pure {
        _number + _number;
    }

    // memory
    // storage
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}