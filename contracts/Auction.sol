// SPDX-License-Identifier: MIT
// The SPDX-License-Identifier specifies the license under which the code is released.

pragma solidity ^0.8.19;
// Specifies the Solidity version required by the contract.

import "./BulletinBoard.sol";
// Importing the BulletinBoard contract.

// FirstPriceAuction contract inheriting from BulletinBoard.
contract Auction is BUlletinBoard {

    uint256 private fixedBidAmount = 1000000 wei; // Fixed amount required to participate in the auction.
    uint256 private requiredParties = 10; // Number of parties required for the bid reveal.
    uint256 private revealedParties = 0; // Number of parties that have revealed their bids.
    uint256 private highestBid; // Variable to store the highest bid.
    address private winner; // Address of the winner.
    bytes32[] private revealedBids; // Array to store revealed bids.
    bytes32 private salt1 = blockhash(block.number - 1);

    // Constructor function.
    constructor() {
         
    }

    // Struct to represent a bid commitment.
    struct Commit {
        address sender;
        string name;
        bytes32 commit;
        uint64 blockNumber;
        bool revealed;
    }

    Commit[] public commitHistory; // Array to store commitment history.

    mapping(address => Commit) public commits; // Mapping to track commitments for each address.

    // Struct to represent a bid reveal.
    struct Reveal {
        address sender;
        string name;
        uint64 blockNumber;
        uint256 bid;
        bytes32 salt2;
    }

    Reveal[] public revealHistory; // Array to store reveal history.

    // Event emitted when a bid commitment is made.
    event CommitBid(address sender, string name, bytes32 bidCommit, uint64 blockNumber);

    // Event emitted when all required parties have revealed their bids.
    event RevealedBidsEmitted(Reveal[] revealedBids);

    event CommitBidsEmitted(Commit[] commitBids);

    // Event emitted when the auction winner is determined.
    event WinnerAnnounced(address winner, uint256 highestBid);

    // Function to commit a bid to the auction.
    function commit(bytes32 bidHash) external payable {
        // Require correct payment amount.
        require(msg.value == fixedBidAmount, "Incorrect payment amount");

        

        // Get the current block number.
        uint64 currentBlock = uint64(block.number);

        // Get the nickname associated with the sender's address.
        // unit256 bidVal = unit256(bidHash);
        string memory _name = getNicknameByAddress(msg.sender);
        // bytes32 commitedVal = getSaltedHash(bidHash, salt1);

        // Record the bid commitment.
        commits[msg.sender].name = _name;
        commits[msg.sender].commit = bidHash;
        commits[msg.sender].blockNumber = uint64(block.number);
        commits[msg.sender].revealed = false;

         
        // Add the bid commitment to the commit history.
        commitHistory.push(Commit({
            sender: msg.sender,
            name: _name,
            commit: bidHash,
            blockNumber: currentBlock,
            revealed: false
        }));

        if (revealedParties == requiredParties - 1) {
            emit CommitBidsEmitted(commitHistory);
        }

        // Emit an event indicating the bid commitment.
        emit CommitBid(msg.sender, commits[msg.sender].name, commits[msg.sender].commit, commits[msg.sender].blockNumber);
    }

    // Function to reveal a committed bid.
    function reveal(uint256 bid, bytes32 salt) external {
        // Require that the bid has not been revealed yet.
        require(!commits[msg.sender].revealed, "Already revealed");

        // Mark the bid as revealed.
        commits[msg.sender].revealed = true;

        // Require that the revealed hash matches the committed hash.
        // salt = salt1;
        require(getSaltedHash(bid, salt) == commits[msg.sender].commit, "Revealed hash does not match commit");

        // Require that the reveal happened in a later block than the commit.
        require(uint64(block.number) > commits[msg.sender].blockNumber, "Reveal and commit happened on the same block");

        // Require that the reveal happened within the allowed block range.
        require(uint64(block.number) <= commits[msg.sender].blockNumber + 10, "Revealed too late");

        // Update the highest bid if the revealed bid is higher.
        // uint256 bidVal = uint256(bid);
        if (bid > highestBid) {
            highestBid = bid;
            winner = msg.sender;
        }

        revealedParties++; // Increment the count of revealed parties.



        // Transfer the fixed bid amount to the sender.
        // payable(msg.sender).transfer(fixedBidAmount);

        uint64 currentBlock = uint64(block.number);
        string memory _name = getNicknameByAddress(msg.sender);

         

        // Add the reveal to the reveal history.
        revealHistory.push(Reveal({
            sender: msg.sender,
            name: _name,
            bid: bid,
            salt2: salt,
            blockNumber: currentBlock
        }));

        // If all required parties have revealed, emit an event with the reveal history.
        if (revealedParties == requiredParties) {
            emit RevealedBidsEmitted(revealHistory);
        }

        // If all required parties have revealed, announce the winner.
        if (revealedParties == requiredParties) {
            emit WinnerAnnounced(winner, highestBid);
        }
    }

    // Function to get the salted hash of a value.
    function getSaltedHash(uint256 data, bytes32 salt) view public returns (bytes32) {
        // salt1 = blockhash(block.number - 1);
        return keccak256(abi.encodePacked(address(this), data, salt));
    }

    // Function to get the commitment history.
    function getCommits() external view returns (Commit[] memory) {
        return commitHistory;
    }

    // Function to get the reveal history.
    function getReveals() external view returns (Reveal[] memory) {
        return revealHistory;
    }

    // Function to remove a commitment entry from the array.
    function removeEntryAtIndex(uint256 index) internal {
        // Require that the provided index is within the bounds of the commitHistory array.
        require(index < commitHistory.length, "Invalid index");

        // Shift elements to fill the gap left by removing the entry at the specified index.
        for (uint256 i = index; i < commitHistory.length - 1; i++) {
            commitHistory[i] = commitHistory[i + 1];
        }

        // Pop the last element to remove the duplicate entry at the end.
        commitHistory.pop();
    }
}
