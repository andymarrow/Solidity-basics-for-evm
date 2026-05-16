# SENDING ETHER
## task 1

Solidity Addresses
Let's talk about the address data type in Solidity!

An address on the EVM is a 160 bits long, or a 40 character, hexadecimal string:

address a = 0xc783df8a850f42e7f7e57013759c285caa701eb6;
 This is valid Solidity! We can store a fixed address in our contracts if we need to.

We can also find the sender of the current message:

import "forge-std/console.sol";
contract Example {
    constructor() {
        console.log( msg.sender ); // 0xc783df8a850f42e7f7e57013759c285caa701eb6
    }
}
 Here we are logging the address of the account calling this contract.

 What is msg? We'll take a closer look at EVM messages in Details.

 Your Goal: Store the Owner
Create a public address state variable called owner on the contract
Next create a constructor function which will store the msg.sender in owner
 Since the constructor is only called once during contract deployment, storing the owner is not all too uncommon, especially if you need to have an administrative role. Of course, keep in mind that the administrative role can infringe on the decentralized nature of your contract!


 ## task 2

 Receive Function
In the latest versions of Solidity, contracts cannot receive ether by default.

In order to receive ether, a contract must specify a payable function. This is another keyword which affects the function's mutability similar to view and pure.

Let's see a payable function in action:

import "forge-std/console.sol";
contract Contract {
    function pay() public payable {
        console.log( msg.value ); // 100000
    }
}
 Here the msg.value represents the amount of ether, in Wei, sent to the pay function. By simply adding the payable keyword to this function, it gains the ability to accept ether. Once received, the ether is automatically added to the contract's balance—no additional steps required!

 What if someone tried to send a payment to a nonpayable function? The transaction will fail, sending the ether back to the sender.

In the case above we used the method pay as a payable function. This means we have to call this function in order to send the ether to the contract. What if we wanted to send it directly without specifying a method?

Turns out, we can do that too:

import "forge-std/console.sol";
contract Contract {
    receive() external payable {
        console.log(msg.value); // 100000
    }
}
 You'll notice that receive does not use the function keyword. This is because it is a special function (like constructor). It is the function that runs when a contract is sent ether without any calldata, or when the calldata does not match a function signature on the contract.

The receive function must be external, payable, it cannot receive arguments and it cannot return anything.

 Another option to receive ether without specifying a function signature on a contract is to use a payable fallback function.

 Your Goal: Receive Ether
Add a function to the contract that will allow it to receive ether on a transaction without any calldata.

## task 3

Transferring Funds
We can make any regular function payable. This allows us to differentiate the purpose of the ether coming into the smart contract.

Perhaps a contract has two stored addresses and we want to be able to pay each:

contract Contract {
    address public a;
    address public b;
    
    constructor(address _a, address _b) {
        a = _a;
        b = _b;
    }

    function payA() public payable {
        (bool s, ) = a.call{ value: msg.value }("");
        require(s);
    }

    function payB() public payable {
        (bool s, ) = b.call{ value: msg.value }("");
        require(s);
    }
}
 We have two pay methods payA and payB which will transfer ether to the respective address. It takes a uint amount of Wei and transfers it from the contract account to the address.

 Your Goal: Transfer Tips
Let's create a way to tip the contract owner!

Create a public payable function tip which sends any of its received ether to the owner.


## task 4


Contract Account
Within contracts, the this keyword can explicitly converted to an address:

import "forge-std/console.sol";
contract Contract {
	constructor() {
		console.log( address(this) ); // 0x7c2c195cd6d34b8f845992d380aadb2730bb9c6f
		console.log( address(this).balance ); // 0
	}
}
 Using this we can easily find the address and balance of the contract!

 Let's take a look at another use for the Solidity keyword this in Details.

 Your Goal: Charity Donation
Let's take all funds that were passed to the receive function and donate them to charity. We'll do this in two steps.

First, modify the constructor to accept a new argument: the charity address.
Next, add a new function called donate. When this function is called transfer all remaining funds in the contract to the charity address.


### the details 

this Message Calls
In Solidity the this keyword give us access to the contract itself. We can call functions on it using the . operator:

import "forge-std/console.sol";
contract Example() {
    function a() public view {
        // NOTE: this makes an external function call
        console.log( this.b() ); // 3
    }
    function b() public pure returns(uint) {
        return 3;
    }
}
 Calling this.b() will target the b function with an external message call back into the example contract. We generally want to avoid this behavior unless there's a good reason for it.

## task 5

Self Destruct
Contracts can destroy themselves by using the SELFDESTRUCT opcode on the EVM! This opcode actually refunds ether in order to incentivize cleaning up the blockchain of unused contracts.

Let's see it in action:

contract Contract {
    uint _countdown = 10;

    constructor() payable { }

    function tick() public {
        _countdown--;
        if(_countdown == 0) {
            // NOTE: we must cast to address payable here
            // some solidity methods protect 
            // against accidentally sending ether
            selfdestruct(payable(msg.sender));
        }
    }
}
 After 10 calls to the tick function the Contract will selfdestruct! 

So you might be wondering, why did we provide msg.sender as the argument to selfdestruct? 

The address provided to the selfdestruct function gets all of the ether remaining in the contract! Ether sent to the payable constructor will be refunded to the final caller of the tick function.

 Before self-destructing your smart contract you may want to consider the repercussions. Let's discuss this in details.

 Your Goal: Self Destruct
When the donate function is called, trigger a selfdestruct in the contract!

 The selfdestruct will send all remaining funds to the address passed in, so it might be a good candidate to replace the existing functionality in your donate function by sending the funds to the charity! Just be sure to cast the address to an address payable as shown in the example above.

### the details 

Self-Destruct Repercussions
When you call selfdestruct on a contract account, the bytecode is cleared. The contract will no longer be able to respond to ether transfers.

If you are going to use selfdestruct, you should be sure that nobody will accidentally send ether to your contract in the future. There may be no recourse for getting that ether back if they do. Future funds sent to this address could be locked forever! 

 You might assume that once a contract's code is cleared from an address, that's the end of the story. However, with the later introduction of the CREATE2 opcode, you now have the ability to redeploy the same code to the same address. Unlike the traditional method, which relies on the sender's address and account nonce, CREATE2 uses a salt and the contract creation code to determine the contract address. Intrigued? Check out this tutorial for more.

Instead of self-destructing the contract, you could consider setting storage variables so that nobody can call the function. Then you revert the transaction if they try to call a function or send ether in the future! This is probably the safest course of action.

 We will talk about how to do this when we discuss reverting! 

# LEARNING REVERT

## task 1


Reverting Transactions
In the EVM the main opcode to revert a transaction is REVERT. There are three ways to invoke the REVERT opcode from Solidity are assert, require and revert. We'll focus on the last two for now (see this stage's details section for more on assert).

We can revert a transaction in Solidity by using the require function and the revert statement.

A require statement has two forms:

require(someBooleanCondition);
require(someBooleanCondition, "Optional error message");
 These will revert if someBooleanCondition is false. We can use these to check for all kinds of conditions.

The revert keyword also has two forms:

// old syntax to revert with a string
revert("Some error message");
// new syntax to revert with a custom error
revert SomeCustomError(arg1, arg2, ...);
 Notice that, either way, revert does not take a boolean condition. Revert will always revert, so you will usually see it wrapped in a conditional statement:

if(someCondition) {
     revert SomeCustomError(arg1, arg2, ...);
}
Both revert and require use the REVERT opcode, they just provide different syntaxes to do so. The recommended approach is to use custom errors in most cases as they provide a gas-efficient way to identify and debug issues.

 A custom error, like a function, is identified by the first 4 bytes of the keccak256 hash of its canonical representation, which includes its name and parameter types. In contrast, using string literals for error messages can consume many more bytes, as we discussed in our lesson on string literals.

 Your Goal: Require 1 Ether
Add a payable constructor method that requires a 1 ether deposit.

If at least 1 ether is not sent to the constructor, revert the transaction.

 There are globally available ether units such as ether that you can use instead of having to convert from Wei (1 ether == 1e18). See Ether Units.

 ### in detail 

 The Assert Keyword
assert, require, and revert halt further code execution and immediately return control to the calling code, typically with an error message or code.

These Solidity constructs are akin to throwing exceptions in many other languages, a core error-handling concept. While they all utilize the EVM's REVERT opcode, they differ in both meaning and function. Let's take a look at assert!

Using assert reverts with a Panic(uint256) error. Reserve assert for internal checks and function invariants, which are essentially logical conditions that must always hold true during specific phases of code execution.

Example usage of assert looks like:

function withdrawEverything() external {
    // withdraw everything to the msg sender
    (bool s, ) = msg.sender.call { value: address(this).balance }("");
    require(s);
    

    // this should never be false here!
    assert(address(this).balance == 0);
}

## task 2


Restricting by Address
We can provide certain roles to an address.

For instance, let's say we had an address with the privilege of creating new game items:

contract Game {
    address itemCreator = 0xc783df8a850f42e7F7e57013759C285caa701eB6;

    error NotItemCreator(address);

    function createItem() external {
        if(msg.sender != itemCreator) {
            revert NotItemCreator(msg.sender);
        }
        // TODO: create the item!
    }
}
 This function createItem may be public, but there's only one address that can call it without the transaction reverting!

 Your Goal: Owner Withdrawal
Create a public function withdraw that will withdraw all funds from the contract and send them to the deployer of the contract.
Require that only the deployer of the contract be allowed to call this function. For all other addresses, this function should revert.
 The deployer of the contract is msg.sender of the constructor.



## task 3

Function Modifiers
We can write modifiers on functions to run logic before and/or after the function body.

Let's see an example:

import "forge-std/console.sol";
contract Example {
    function logMessage() public view logModifier {
        console.log("during");
    }

    modifier logModifier {
        console.log("before");
        _;
        console.log("after");
    }
}
 Let's say we called logMessage, what would you expect the order of the logged messages to be? 

It would be:

before
during 
after
Why? 

Notice that the logMessage function signature is decorated with the logModifier modifier.

This modifier can add behavior to the function before and after the function body runs. The _ in the modifier body is where the function body of the modified function will run.

 Your Goal: Require Owner
You'll notice that the onlyOwner modifier has been added to each of the configuration functions in this contract. Only problem is, it doesn't currently do anything!

Update the onlyOwner modifier to require that only the owner address can call these functions without reverting.

 Remember to use the _ to indicate where the function body should go!

# CALLDATA

## task 1

Interfaces
The easiest way to enable one contract to interact with another is by defining the target contract. Interfaces serve this purpose; for example:

interface IToken {
    function getBalance(address user) external;
}
 We can use this interface to properly communicate with a token contract that implements the getBalance method:

// tokenAddress: a contract adddress we want to communicate with
// userAddress: the address we want to lookup the balance for
uint balance = IToken(tokenAddress).getBalance(userAddress);
Behind the scenes Solidity is creating a message call that encodes the calldata for this getBalance call.

 Your Goal: Alert Hero
Use the IHero interface and the hero address passed into sendAlert to alert the hero from the Sidekick contract.

## task 2


Function Signature
The first step to forming calldata manually is taking the keccak256 hash of the function signature you are targeting.

So, for example, if we we are trying to call rumble:

function rumble() external;
 We need to take the keccak256 hash of rumble() and grab the first 4 bytes. As it turns out, those 4 bytes are 0x7e47cd7e. This would be our entire calldata to make the function call to rumble on a contract!

 Your Goal: Alert Hero, Manually
Alert the Hero, manually this time!

Fill in the function signature for the Hero's alert function. Notice that we are taking the first 4 bytes of the hash of this function and passing it in as calldata to the hero.


## task 3

Encode With Signature
As a bit of a shortcut to the previous stage, we can use the method abi.encodeWithSignature! This method will do everything we did in the last stage, in one function.

// replace this:
bytes4 memory payload = abi.encodePacked(bytes4(keccak256("rumble()")));

// with this:
bytes memory payload = abi.encodeWithSignature("rumble()");
And if you want to add arguments, you can add them to signature and as comma separated arguments to the encodeWithSignature method. If rumble took two uint arguments, we could pass them like this:

bytes memory payload = abi.encodeWithSignature("rumble(uint256,uint256)", 10, 5);

(bool success, ) = hero.call(payload);
Your Goal: Alert the Hero with Arguments
Alert the Hero by calling alert and passing the number of enemies and whether or not they are armed 

 Be careful! The type uint is an alias for uint256 but only uint256 will work with abi.encodeWithSignature. Click on the details to learn more.

 ### in detail 

 Encoding Calldata
Behind the scenes, abi.encodeWithSignature is doing a few things for us and it's helpful to take a look behind the curtain to understand why it will behave the way it does!

Let's take a look at an example:

contract Example {
   function sendData(address x) external {
       (bool s, ) = x.call(
           abi.encodeWithSignature("receiveData(uint256)", 5)
        );
       require(s);
   } 
}
How does abi.encodeWithSignature turn these arguments into calldata? It's a process that involves a few steps:

Taking the keccak256 hash of the function signature receiveData(uint256)
Taking the first four bytes of the keccak256 hash
Appending the value 5, padded out to 256 bits
The resulting calldata is: de947c85 (four bytes of the signature) + 0000000000000000000000000000000000000000000000000000000000000005 (the argument padded out to 256 bits).

 Check our work! You can put the receiveData(uint256) input into this keccak256 online tool to see that the function signature is what we said it was here.

Signature Issues
You'll notice that this makes the function signature part of the calldata very brittle! One small change to the signature and you will encode entirely different calldata. The smart contract on the other end will not understand the value you're trying to call in that case!

Let's say for example, you forget to take out the argument name and you type out abi.encodeWithSignature("receiveData(uint256 x)", 5). The resulting hash from keeping the x in there is going to be entirely different from the one we came up with! This makes the abi.encodeWithSignature notoriously tricky.

Here's some rules to follow when you type in the function signature:

Only include the function name: don't include any visibilities or other keywords
Include all variables, comma-delimited: make sure that all your arguments are specified in a comma delimited list without spaces. For instance receiveData(uint256,uint256) is good but receiveData(uint256 uint256) and receiveData(uint256, uint256) will not work.
Be careful not to use aliases! The keyword uint is shorthand for uint256. You'll need to use uint256 or the call data encoding will not work.

## task 4


Taking Calldata
If we take calldata as an argument to a function we can pass that arbitrary calldata along to another contract.

This can be super useful, especially in contracts that require many people to pass their approval before a transaction is executed. We'll talk about governance proposals and multiple-signature wallets later on in the course and you'll see that storing calldata for later use is critical for maximum flexibility in these cases.

 Your Goal: Pass Calldata
The Sidekick needs to be able to relay any calldata along to the Hero. Update the relay function to take the data and send it to the Hero as calldata.



## task 5


Fallback
When data is sent to a contract and it doesn't match any of the contract's function 'identifiers' (the first 4 bytes of the hash of the function's signature), the contract's fallback function will be triggered. This means that if you send a random 4-byte value to a contract, it will most likely not match any function and will invoke the fallback function if one exists.

The same holds true if you send less or more than 4 bytes! As long as those initial 4 bytes don't match a function identifier, the fallback function gets triggered.

 Your Goal: Trigger the fallback
In the makeContact method, send some calldata to the Hero contract that will trigger its fallback function.






# ESCROW

## task 1

State Variables
We'll have three parties involved in the Escrow:

 Depositor - The payer of the Escrow, makes the initial deposit that will eventually go to the beneficiary.
 Beneficiary - The receiver of the funds. They will provide some service or good to the depositor before the funds are transferred by the arbiter.
 Arbiter - The approver of the transaction. They alone can move the funds when the goods/services have been provided.
For this first stage, let's create these addresses as public storage variables!

 Your Goal: Addresses
Create three public storage variables for the addresses of the depositor, beneficiary and arbiter

## task 2


Constructor Storage 
Each time that a depositor, arbiter and beneficiary come to an agreement upon Escrow terms, they can deploy a contract.

The depositor will be the deployer of the contract. They will ask the arbiter and beneficiary for addresses that those two parties have access to. Then the depositor will provide those addresses as the arguments to the Escrow contract for storage.

 Your Goal: Store Addresses
Create a constructor which takes two arguments: an address for the arbiter and an address for the beneficiary (in that order). Store these variables in the corresponding state variables.
The depositor is the address deploying the contract, so take this address and store it in the depositor state variable.

## task 3

Funding 
It's time to fund the contract!

The depositor will send some ether to the contract, which will be used to pay the beneficiary after the transfer is approved by the arbiter.

 Your Goal: Payable
Modify the constructor function to make it payable.

## task 4

Approval
After the contract has been deployed with the appropriate amount of funds, the beneficiary will provide the good or service. They are now secure in knowing that the money is on its way! 

Once the good or service is provided, the arbiter needs a way to approve the transfer of the deposit over to the beneficiary's account. 

Let's add this mechanism to our contract!

 Your Goal: Approve
Create an external function called approve.
This function should move the contract's balance to the beneficiary's address.

## task 5

Lock it Down 
There's only one address that should be able to call the approve method: the arbiter. 

This is their role in the escrow transaction, to decide when the funds can be transferred.

 Your Goal: Security
If anyone tries to call approve other than the arbiter address, revert the transaction.

## task 6

Events 
It's important for servers and front-ends to be able to listen and index on important blockchain events so that they can show the most up-to-date information to users! An event can be declared and emitted like this:

contract X {
  event MyEvent(address);

  function importantThing() external {
    emit MyEvent(msg.sender);
  }
}
Let's create an event so it is easy for an application to subscribe to when the Escrow is approved!

 Your Goal: Approved
Create an event called Approved which takes a single uint parameter: the balance that is sent to the beneficiary.

Emit this event from within the approve function.