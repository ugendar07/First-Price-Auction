// SPDX-License-Identifier: UNLICENSED
// The SPDX-License-Identifier specifies the license under which the code is released.


pragma solidity ^0.8.19;
// Specifies the Solidity version required by the contract.

import "@openzeppelin/contracts/access/Ownable.sol";
// Importing the Ownable contract from the OpenZeppelin library to manage ownership.


contract BUlletinBoard {
    // The main contract named "BulletinBoard" inheriting from Ownable.


    // Structure to represent a message, containing various fields.
    struct Message {
        address writerAddress;
        string Name;
        string message;
        bytes32 topic;
        uint256 postTime;
        bytes signature;
        
    }

        address[] private writerAccounts;   // An array to store unique writer addresses.
        Message[] public messages;  // An array to store messages.

        // Constructor function. calls only once when the contract deployed
        constructor(){

    }


    // Event emitted when a new message is posted.
    event MessageInfo(
        address writerAddress,
        string Name,
        string message,
        bytes32 topic,
        uint256 postTime,
        bytes signature
    );


    // Event emitted when writer information is updated.
    event WriterInfo(address writerAddress, string nickname);

    // Mapping to store the nickname associated with each writer address.
    mapping(address => string) public addressToNickname;

     
    // Function to post a new message.
    function postMessage(string memory _Name, string memory _message, bytes32 _topic , bytes memory _signature) public {
        bool isDuplicate = false;   // Flag to determine if the writer has already posted a message.
        string memory writerName;   // Variable to store the writer's name in case of a duplicate message.

        // Check if the writer has already posted a message. 
        for (uint256 i = 0; i < messages.length ; i++) {
            if (messages[i].writerAddress == msg.sender) {
                writerName = messages[i].Name;
                isDuplicate = true;
                break;
            }
        }

        if (!isDuplicate) {
            // If it's a new writer, add them to the list.
            writerAccounts.push(msg.sender);

            // Update writer information by associating the writer's address with their provided name.
            addressToNickname[msg.sender] = _Name;

            // Emit an event to inform that the writer's information has been updated.
            emit WriterInfo(msg.sender, _Name);
            
            // Create a new message and add it to the list of messages.
            messages.push(Message(msg.sender, _Name, _message, _topic, block.timestamp ,_signature));

            // Emit an event to inform that a new message has been posted.
            emit MessageInfo(msg.sender, _Name, _message, _topic, block.timestamp,_signature);
            }
        else{
            // If the writer has already posted a message, reuse the writer's name.

            // Create a new message using the stored writer's name.
            messages.push(Message(msg.sender, writerName, _message, _topic, block.timestamp ,_signature));

            // Emit an event to inform that a new message has been posted.
            emit MessageInfo(msg.sender, writerName, _message, _topic, block.timestamp,_signature);
        }
        
    }

     
    // Function to get all writer addresses.
    function getWriterAccounts() view public returns (address[] memory ) {
        return (writerAccounts );
    }


    // Function to get a specific writer address by index.
    function getWriterAccount(uint256 _index) view public returns (address) {
        // Ensure that the provided index is within the bounds of the writerAccounts array.
        require(_index < writerAccounts.length, "Invalid index");   

        // Return the writer address at the specified index in the writerAccounts array.
        return writerAccounts[_index];
    }


    // Function to get the total number of writers.
    function getWriterCount() view public returns (uint) {
        return writerAccounts.length;
    }


    // Function to get message details by index.
    function getMessage(uint256 _index) view public returns (address, string memory, string memory, bytes32, uint256 , bytes memory) {
        // Ensure that the provided index is within the bounds of the messages array.
        require(_index < messages.length, "Invalid index");

        // Retrieve the message information at the specified index in the messages array.
        Message storage msgInfo = messages[_index];

        // Return the details of the message, including writer address, name, message content, topic, post time, and signature.
        return (
            msgInfo.writerAddress, 
            msgInfo.Name, 
            msgInfo.message, 
            msgInfo.topic, 
            msgInfo.postTime , 
            msgInfo.signature
        );
    }


    // Function to get messages posted by a specific writer address.
    function getMessageByAddress(address _writerAddress) view public returns (address[] memory, string[] memory, string[] memory, bytes32[] memory, uint256[] memory , bytes[] memory) {

        // Variable to count the number of messages posted by the specified writer address.
        uint256 count = 0;  
    
        // Count the number of messages posted by the specified writer address.
        for (uint256 i = 0; i < messages.length; i++) {
            if (messages[i].writerAddress == _writerAddress) {
            count++;
            }
        }


        // Arrays to store details of messages posted by the specified writer address.
        address[] memory writerAddresses = new address[](count);
        string[] memory names = new string[](count);
        string[] memory messagess = new string[](count);
        bytes32[] memory topics = new bytes32[](count);
        uint256[] memory postTimes = new uint256[](count);
        bytes[] memory signature = new bytes[](count);

        uint256 currentIndex = 0;   // Variable to keep track of the current index in the arrays.
        
        
        // If messages are found, populate arrays with message details.
        if(count!=0){
            // Populate arrays with message details.
            for (uint256 i = 0; i < messages.length; i++) {
                if (messages[i].writerAddress == _writerAddress) {
                    // Store details of each message posted by the specified writer address.
                    writerAddresses[currentIndex] = messages[i].writerAddress;
                    names[currentIndex] = messages[i].Name;
                    messagess[currentIndex] = messages[i].message;
                    topics[currentIndex] = messages[i].topic;
                    postTimes[currentIndex] = messages[i].postTime;
                    signature[currentIndex] = messages[i].signature;
                    currentIndex++;
                }
            }

        // Return arrays containing message details.
        return (writerAddresses, names, messagess, topics, postTimes , signature);
        }else{
            // If no messages are found, revert with an error message.
            revert("Message not found");
        }
    
    }


    // Function to get the total number of messages.
    function getMessageCount() view public returns (uint) {
        return messages.length;
    }

    // Function to get the nickname associated with a writer address.
    function getNicknameByAddress(address _writerAddress) public view returns (string memory) {
        return addressToNickname[_writerAddress];
    }
}
