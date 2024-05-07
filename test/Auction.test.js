// const { expect } = require("chai");
// const { ethers } = require("ethers");
const crypto = require('crypto');

const Auction = artifacts.require("Auction");

contract("Auction", (accounts) => {
    let instance;

    before(async () => {
        instance = await Auction.new();
    });




    //%%%%%%%%%%%%%%%%%%%%%%% The 1st test case  %%%%%%%%%%%%%%%%%%%%%%%%%%
    it("should commit a bid", async function() {
        bid = 150
        salt = 'abcsdetwb'
        byt_bid = await web3.utils.utf8ToHex(bid)
        byt_salt = await web3.utils.utf8ToHex(salt)
        comitVal = await instance.getSaltedHash(bid,byt_salt)

        await instance.commit(comitVal, {value: 1000000, from: accounts[0]});
        const commits = await instance.getCommits();
        await instance.reveal(bid,byt_salt)
        expect(commits.length).to.equal(1);
        expect(commits[0].sender).to.equal(accounts[0]);
    });


    //%%%%%%%%%%%%%%%%%%%%%%% The 2st test case  %%%%%%%%%%%%%%%%%%%%%%%%%%
    it("should reveal a bid", async function() {
        bid = 100
        salt = 'abc'
        byt_bid = await web3.utils.utf8ToHex(bid)
        byt_salt = await web3.utils.utf8ToHex(salt)
        commitVal = await instance.getSaltedHash(bid,byt_salt)
        // console.log("the value that need to be committed",commitVal)
        
        const { logs } = await instance.commit(commitVal, { value: 1000000 , from: accounts[1] });
        // await ethers.provider.send("evm_increaseTime", [11]);
        // await ethers.provider.send("evm_mine", []);
        await instance.reveal(bid , byt_salt,{from:accounts[1]});
        const reveals = await instance.getReveals();
        // console.log("the reveals are :",reveals)
        expect(reveals.length).to.equal(2);
        expect(reveals[1].sender).to.equal(accounts[1]);
    });

  
    //%%%%%%%%%%%%%%%%%%%%%%% The 3nd test case  %%%%%%%%%%%%%%%%%%%%%%%%%%

    it("should emit WinnerAnnounced event", async function() {
        const salt = crypto.randomBytes(16).toString('hex');
        const salt1 = await web3.utils.utf8ToHex(salt)
        // console.log('Random salt:', salt1);    
        bid = 200 
     
        byt_bid =  await web3.utils.utf8ToHex(bid)
     
        comitVal = await instance.getSaltedHash(bid,salt1)
        await instance.commit(comitVal , { value: 1000000 , from:accounts[2] })
        await instance.reveal(bid,salt1 , {from: accounts[2]})

        const salt2 = crypto.randomBytes(16).toString('hex');
        const salt3 = await web3.utils.utf8ToHex(salt2)
        const bid3 =  290
        comitVal1 = await instance.getSaltedHash(bid3,salt3)
        await instance.commit(comitVal1 , { value: 1000000 , from:accounts[3] })
        reveal =  await instance.reveal(bid3,salt3 , {from: accounts[3]})

        const salt4 = crypto.randomBytes(16).toString('hex');
        const salt5 = await web3.utils.utf8ToHex(salt4)
        const bid4 = 270
        comitVal2 = await instance.getSaltedHash(bid4,salt5)
        await instance.commit(comitVal2 , { value: 1000000 , from:accounts[4] })
        await instance.reveal(bid4,salt5 , {from: accounts[4]})

        const salt6 = crypto.randomBytes(16).toString('hex');
        const salt7 = await web3.utils.utf8ToHex(salt6)
        const bid5 = 310
        comitVal3 = await instance.getSaltedHash(bid5,salt7)
        await instance.commit(comitVal3 , { value: 1000000 , from:accounts[5] })
        await instance.reveal(bid5,salt7 , {from: accounts[5]})


        const balance = await web3.eth.getBalance(instance.address);

        // console.log("the balance of the smart contract is :",balance)

        expect(balance).to.equal('6000000');
    });


    //%%%%%%%%%%%%%%%%%%%%%%% The 4st test case  %%%%%%%%%%%%%%%%%%%%%%%%%%
    it("should emit CommitBid event", async function() {

        
    
        const salt8 = crypto.randomBytes(16).toString('hex');
        const salt9 = await web3.utils.utf8ToHex(salt8)
        const bid6 = 320
        comitVal4 = await instance.getSaltedHash(bid6,salt9)
        await instance.commit(comitVal4 , { value: 1000000 , from:accounts[6] })
        await instance.reveal(bid6 ,salt9 , {from: accounts[6]})

        const salt10 = crypto.randomBytes(16).toString('hex');
        const salt11 = await web3.utils.utf8ToHex(salt10)
        const bid7 = 300
        comitVal5 = await instance.getSaltedHash(bid7,salt11)
        await instance.commit(comitVal5 , { value: 1000000 , from:accounts[7] })
        await instance.reveal(bid7,salt11 , {from: accounts[7]})

        const salt12 = crypto.randomBytes(16).toString('hex');
        const salt13 = await web3.utils.utf8ToHex(salt12)
        const bid8 = 130
        comitVal6 = await instance.getSaltedHash(bid8,salt13)
        await instance.commit(comitVal6 , { value: 1000000 , from:accounts[8] })
        await instance.reveal(bid8,salt13 , {from: accounts[8]})

        const salt14 = crypto.randomBytes(16).toString('hex');
        const salt15 = await web3.utils.utf8ToHex(salt14)
        const bid9 = 125
        comitVal7 = await instance.getSaltedHash(bid9,salt15)
        commit = await instance.commit(comitVal7 , { value: 1000000 , from:accounts[9] })
        reveal = await instance.reveal(bid9,salt15 , {from: accounts[9]})
        // console.log("the revealed values are :",reveal)
        let winner 


        const event = commit.logs.find((log) => log.event === 'CommitBidsEmitted');
        console.log('\n \n')
        console.log("the committments are :")
        event.args.commitBids.forEach(( commitBid , index) => {
            const sender = commitBid[0];
            const bid = commitBid[2];
            console.log(`Bid ${index + 1}: Sender - ${sender} `);
            console.log(`Bid Commited - ${bid}`);
            console.log("\n")
        });
        console.log('\n')
        console.log('\n')
        const event2 = reveal.logs.find((log) => log.event === 'WinnerAnnounced');
        const event1 = reveal.logs.find((log) => log.event === 'RevealedBidsEmitted');
        console.log("the revealed bids are :")
        event1.args.revealedBids.forEach((bidInfo, index) => {
            const sender = bidInfo[0];
            const bid = bidInfo[3];
            console.log(`Bid ${index + 1}: Sender - ${sender}, Bid - ${bid}`);
        });
        console.log('\n \n')
        console.log("the winning bid is :",event2.args.highestBid.toString())
        console.log("the winner is :",event2.args.winner)

        expect(event2.args.winner).to.equal(accounts[6]);

    });

   
})