# First-Price Auction on Ethereum Blockchain

## Overview

This project implements a first-price auction smart contract on the Ethereum blockchain. In a first-price auction, participants bid on an item, and the highest bid wins, paying the price they bid. The smart contract facilitates the auction process, ensuring transparency, fairness, and security.


## Smart Contract Details
We implement a multiplicative group wrapper on top of the Elliptic curve group (which is essentially an additive group). Using these group operations, we implement HASH based commitments, Oblivious Transfer and the encoding scheme for our auction protocol. We also make use of SHA-256 hashing function from ETHEREUM library.

The protocol requires use of a Bulletin Board which is simulated using Distributed memory. For this, we make use of Blockchain Based Bulletin Board.

The smart contract is written in Solidity, the language used for Ethereum smart contracts. Here's a brief overview of the contract functionalities:

- `commitBid(uint256 bidAmount)`: Allows participants to place bids by specifying the bid amount and a security deposit.
- `revealBid()`: Allows participants to reveal their bids before the auction ends.
- `endAuction()`: Ends the auction and determines the winner based on the highest bid and distributes the security deposit if revealed properly.

## Testing

Before deploying the smart contract to the main Ethereum network, it's crucial to thoroughly test it on a test network like Ropsten or Rinkeby. Use test cases to ensure the contract behaves as expected in various scenarios.

 

## License

This project is licensed under the [MIT License](LICENSE).



## Acknowledgments

- Solidity documentation
- Ethereum community



## Contact
For questions or inquiries, please contact [ugendar](mailto:ugendar07@gmail.com) .

 
