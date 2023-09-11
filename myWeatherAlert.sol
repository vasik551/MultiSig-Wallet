// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
   * @title QuickInformacia
   * @dev Weather warning smart contract
   * @custom:dev-run-script file_path
   */

// Import Ownable from OpenZeppelin library for access control
import "@openzeppelin/contracts/access/Ownable.sol";

// Weather Forecast and Early Warning System smart contract
contract WeatherWarning is Ownable {
    // Mapping to store warnings by location
    mapping(string => string) public warnings;

    // Event to log when a warning is set
    event WarningSet(string location, string warning, address indexed setter);

    // Array of locations and warning messages
    string[] public locations;
    string[] public warningMessages;

    // Constructor to initialize locations and warning messages
    constructor() {
        locations = ["City A", "City B", "City C"];
        warningMessages = ["Heavy Rain Expected", "High Wind Alert", "Flash Flood Warning"];
    }

    // Function to generate a random warning message and set it automatically
    function generateWarning() public onlyOwner {
        uint256 randomLocationIndex = uint256(keccak256(abi.encodePacked(block.timestamp))) % locations.length;
        uint256 randomWarningIndex = uint256(keccak256(abi.encodePacked(block.difficulty))) % warningMessages.length;

        string memory location = locations[randomLocationIndex];
        string memory warning = warningMessages[randomWarningIndex];

        // Automatically set the generated warning
        setWarning(location, warning);
    }

    // Function to set a warning for a specific location
    function setWarning(string memory location, string memory warning) public onlyOwner {
        warnings[location] = warning;
        emit WarningSet(location, warning, msg.sender);
    }

    // Function to retrieve a warning for a specific location
    function getWarning(string memory location) public view returns (string memory) {
        return warnings[location];
    }
}

