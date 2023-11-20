// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";

contract ProduceTracker is Ownable {
    struct Location {
        uint timeStamp;
        uint32 zipCode;
        bool isRefrigerated;
    }

    struct Produce {
        bool isRecalled;
        Location[] locations;
    }

    mapping(string => Produce) public allProduce;
    //This maps a zip code to all the keys of vegetables that have gone through it.
    mapping(uint32 => string[]) public allProduceKeys;

    function addKeyToLocation(uint32 zipCode, string memory key) private {
        string[] storage currentLocation = allProduceKeys[zipCode];
        currentLocation.push(key);
    }

    function initializeProduce(
        uint32 zipCode,
        bool isRefrigerated,
        string memory key
    ) public {
        Location memory location = Location(
            block.timestamp,
            zipCode,
            isRefrigerated
        );
        Produce storage current = allProduce[key];
        require(current.locations.length == 0, "This banana already exists");
        current.locations.push(location);
        addKeyToLocation(zipCode, key);
    }

    function scanProduce(
        uint32 zipCode,
        bool isRefrigerated,
        string memory key
    ) public {
        Location memory location = Location(
            block.timestamp,
            zipCode,
            isRefrigerated
        );
        Produce storage current = allProduce[key];
        require(
            current.locations.length > 0,
            "Where did this banana come from??"
        );
        //Step 1 - get the last location from current.locations
        uint lastLocation = current.locations.length - 1;
        //Step 2 - require that the zip from that location is not equal to the zipCode provided.
        require(current.locations[lastLocation].zipCode != zipCode);
        current.locations.push(location);
        addKeyToLocation(zipCode, key);
    }

    function getNumberOfSpots(string memory key) public view returns (uint) {
        Produce memory current = allProduce[key];
        return current.locations.length;
    }

    function getAllLocationsFor(
        string memory key
    ) public view returns (Location[] memory) {
        Produce memory thisItem = allProduce[key];
        return thisItem.locations;
    }

    //TODO - be able to handle a certain time frame.

    function reportOutbreak(uint32 zipCode) public {
        string[] memory allKeys = allProduceKeys[zipCode];
        //loop through all the keys
        for (uint i = 0; i < allKeys.length; i++) {
            string memory thisKey = allKeys[i];
            Produce storage thisProduce = allProduce[thisKey];
            thisProduce.isRecalled = true;
        }
    }
}

//pros
// You have complete control and know exactly what the code does.

//cons
//lot more code to look through
//validators have to look through the code more closely.
//You might miss some of the extra functionality.
