# task 1

Storage Variables
Let's begin with storage variables! These variables are stored in a contract's permanent data storage on the blockchain. When you modify a storage variable in a transaction, the updated value becomes globally accessible for subsequent reads and interactions.

In Solidity, declaring a storage variable is as simple as declaring the variable inside of the contract:

contract Contract {
	bool myVariable;
}
The Contract now has a boolean storage variable called myVariable! Sweet. 

 Curious about the initial value of myVariable? Since it's uninitialized, its storage location holds 0x0. In Solidity, that translates to a default value. For booleans like myVariable, the default is false. Therefore, upon contract deployment, myVariable starts off as false.

Now we're going to do two things to our variable: make it public and give it an initial value of true:

contract Contract {
	bool public myVariable = true;
}
 See how we added the keyword public here? This automatically creates a getter function for the variable.

Now we can access the value in myVariable by calling a function on the contract with that very name: myVariable().

 Your Goal: Add two boolean variables
Create two public boolean storage variables on the contract: a and b.

Store true in the variable a and false in the value b.

 You'll see the checkmarks appear on your ABI Validations tab when you have successfully made two public variables a and b. Learn more about ABI Validations in details.


 ABI Validations
On some Solidity stages we'll provide a Validations tab. This tab is intended to help you quickly debug issues with misspellings or unexpected data types.

The validations use the Solidity ABI, which stands for Application Binary Interface. This interface is an output from solidity compiler which provides information about the Smart Contract to an external observer.

For example, the contract on the task tab:

contract Contract {
	bool public myVariable = true;
}
 This contract would have a pretty simple ABI. It would just tell us about the getter function generated for myVariable.

Here is the ABI generated for this contract in JSON:

[
	{
		"inputs": [],
		"name": "myVariable",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]
 Essentially this tells us that there is a function called myVariable that expects no inputs and will return one output: a bool.

That's a pretty good description of the contract to an outside observer! 

For the Goal on the task tab you'll need to create two variables: a and b. We're expecting your ABI will look like this:

[
	{
		"inputs": [],
		"name": "a",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "b",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]
The ABI Validations tab will automatically compile your solidity contract and check to see if it matches what we expect. This can help you diagnose compile-time issues quickly before you run the tests.

# task 2

Unsigned Integers
What the heck is an unsigned integer? 

First, let's go over integers. Integers include all positive and negative numbers without fractions. The numbers -2,-1,0,1,2 are all integers. This range continues in both the positive and negative direction as far as you can count!

To determine if the number is above or below zero we use the sign: + or -. An unsigned integer is an integer that has no sign. 

Solidity has a specific data type for unsigned integers called uint. A uint can be suffixed with the number of bits reserved for it. For instance uint8 means that there are eight bits provided for the value of the variable.

What is the range of unsigned integers in eight bits? 

Eight bits can range from 00000000 to 11111111. This range can represent 256 unique values.

Since the range of unsigned integer values does not include negative numbers, it is simply 0 to 255. In decimal, the unsigned value of 00000000 is 0 and the value of 11111111 is 255. So, the max value a uint8 can store is 255. You can calculate the max value of a uint by doing (2 ^ n) - 1, where n is the number of bits it can use to store the value.

 Wondering what happens if we add two uint8 values together whose sum will exceed 255? Let's take a look at this in details.

 Your Goal: Create Unsigned Integers!
Let's create three public storage unsigned integers in our Contract: a, b, and sum.

Define the variable a as an uint8 with an initial value between 0 and 255.

Define the variable b as an uint16 with a value of at least 256.

The variable sum should be a uint256 with the sum of the values stored in a and b.

# task 3

Signed Integers
Now that we know what an unsigned integer is, let's take a look at a signed integer.

A signed integer can be declared with the keyword int. Just like uint, the keyword int is short for a data type that will store 256 bits of memory, int256.

Since an integer is signed, the range covers both negative and positive numbers. Let's compare the range of a uint8 to an int8:

uint8: Ranges from 0 to 255
int8: Ranges from -128 to 127
 Notice that both ranges cover a total of 256 values, which is the total number of possible values that can be expressed with 8 bits.

 Your Goal: Create Signed Integers!
Create three public storage integers a, b, and difference.

Declare the variables a and b as int8. One of the values must be positive, the other must be negative.

Declare the variable difference as a int16 which is the absolute difference between a and b.

 You can get the absolute difference simply by subtracting the negative number from the positive number. For instance, for the values 10 and -15, the absolute difference would be 25 which is 10 - -15.


 # task 4

 String Literals
We can create strings of characters using double quotes, the string literal "Hello World" is perfectly valid in Solidity.

 You'll often see fixed values described as a literal. The value "Hello World" can be described as a string literal which differentiates it from the string data type. Any fixed value could be a literal, "Hello World", 42, or true.

A string literal can be stored in both the bytes and string types:

bytes msg1 = "Hello World"; 
string msg2 = "Hello World";
 For a long human-readable message it is recommended to use string since it will be easier to read the values from the blockchain storage from the outside (like for a front-end application).

If the string is shorter than 32 bytes, it is more efficient to store it in a fixed-size byte array like bytes32. This simplifies the computation since the memory is allocated ahead of time. On the other hand, both string and bytes will allocate their memory dynamically depending on the size of the string.

How many characters can be stored in bytes32? 

Well this is actually depends on the characters themselves! Many characters in UTF-8 encoding can be represented with 1 byte while others are represented with several bytes. For instance c is encoded by 0x63, while ć is encoded by 0xc487.

So the maximum values would be:

bytes32 msg1 = "cccccccccccccccccccccccccccccccc"; 
bytes32 msg2 = "ćććććććććććććććć"; 
 Adding a character to either string will result in a compile-time error since the string literal would no longer fit into 32 bytes.

 Quite often long strings are stored seperately on other distributed services like IPFS, with a hash representation stored on the blockchain (since storage on a blockchain is expensive!). For example, you could write a legal document and hash the contents along with digital signatures to prove that it was signed. As long as the original document is preserved it can be easily proven that it was signed by rehashing the contents.

 Your Goal: Hello World 
It's time to do Hello World in Solidity! 

Create a public bytes32 storage variable msg1 which stores a string literal "Hello World".

Create a public string storage variable msg2 which stores a string literal that requires over 32 bytes to store.

# task 5


Enum Type
The Enum Type helps us write clean code! 

Consider this example:

if(player.movement == 0) {
    // player is moving up
}
else if(player.movement == 1) {
    // player is moving left
}
 Those comments are helpful, but they aren't exactly a foolproof plan! The movement number is being generated somewhere else in the code. If that ever changed, it would break our code! 

Plus, without the comments, there would be no way to tell which direction is which! 

An enum can clean this up! Let's see:

enum Directions = { Up, Left, Down, Right }
if(player.movement == Directions.Up) {

}
else if(player.movement == Directions.Left) {
    
}
 Much cleaner! 

Not only are the numbers replaced with clear directions, we also have a structure for defining all our directions. We can share this structure, Directions, with other contracts to ensure that if the numbers change they won't break the rest of the code!

 Your Goal: Make Some Food!
In the enum provided you'll see there are four types of Foods 

Take the values and store them in food1, food2, food3, and food4

 Feel free to pick your own favorite foods and use them instead!


























 # SOLIDITY FUNCTIONS
 ## task 1

 Solidity Arguments
The first function we'll talk about is the constructor:

bool public isOpen;

constructor() {
    isOpen = true;
}
 Here we are setting the value of a storage variable on the contract's deployment.

 The constructor for Solidity contracts is quite similar to the constructor in classes of many object-oriented languages. The constructor function is invoked only once during the contract's deployment and never again. It is generally used for setting up initial contract values.

What if we wanted to let the deployer of the contract decide the value of isOpen? 

We can pass an argument to our constructor! Let's see that in action:

bool public isOpen;

constructor(bool _isOpen) {
    isOpen = _isOpen;
}
 Check it out! Now the contract deployer can decide the value of isOpen.

 Notice how the parameter name (_isOpen) has an underscore in front of it? This prevents the variable from having the same name as the storage variable. When the names collide it is referred to as variable shadowing. It can happen in Solidity quite often since we can refer to storage variables without using this. Let's explore this further in details.

 Your Goal: Unsigned Int Constructor
Create a constructor which will take a uint as an argument.
Store this uint value inside a public storage variable called x.


## task 2


Contract Functions
Besides the constructor, contracts can define other functions which can be invoked directly by an externally owned account, or by another contract.

Let's take a look at the Solidity function syntax:

function myFunction() external {
    // do something!
}
 The external visibility specifier allows this function to be accessed from other contracts or from an EOA.

 External visibility is quite similar to the public visibility for functions. External is better than public if you know that you are only calling the function externally (outside the EVM). Public visibility requires more gas because it can be called externally and internally, which complicates the assembly code.

 Your Goal: Increment x
Let's build on your code from the previous stage!

Create an external function called increment that will add 1 to the state variable x.


## task 3

Returning Values
It's time to learn how to return values from Solidity functions!

Let's see an example:

contract Contract {
	bool _isRunning = true;

	function isRunning() external view returns(bool) {
		// return the state variable
		return _isRunning;
	}
}
 The isRunning() function indicates it is returning a boolean data type within the function signature: returns(bool). Once declared, we can use the return keyword to return a boolean value within this function.

Adding the view keyword to the isRunning function signature guarantees it will not modify state variables. You can think of view functions as read-only; they can read the state of the contract but they cannot modify it.

 Your Goal: Add Uint
Create an external view function add which takes a uint parameter and returns the sum of the parameter plus the state variable x.


## task 4


Using Console.log
When developing smart contracts, Foundry makes it super easy to write Solidity unit tests, among many other features. We are using foundry for code execution in this very code lesson! For that reason, you can make use of the console library, for logging console data when you need to test something!

Here's an example:

import "forge-std/console.sol";

contract C {
  function x() external {
    if(condition) {
      console.log("condition was met!");
    }
  }
}
 In this example, if the condition is met, we'll see a message in the test results! This can be very helpful when you're trying to debug your code. You can do this in any of the solidity lessons throughout this course, just remember to import "forge-std/console.sol" at the top of your file!

 Your Goal: Return the Secret
There is a message being passed to you in the winningNumber function. You can use console.log to display this message to the console. It will tell you what to do from there!

 We haven't discussed the calldata keyword just yet. We'll hit this keyword in the upcoming lessons on reference types. For now, know that for reference types (like string), calldata specifies the data location, specifically it is saying the value is located in the message call data!

 ## task 5

 Pure Functions
Occasionally there is the necessity for Solidity functions that neither read from nor write to state. These functions can be labeled as pure.

Let's say we wanted to add together two uint values:

function double(uint x, uint y) external pure returns(uint) {
    return x + y;
}
 This function is just performing simple arithmetic without reading/writing state so we can label it pure.

It's also worth noting there is an alternative syntax for returning values in Solidity:

function double(uint x, uint y) external pure returns(uint sum) {
    sum = x + y;
}
 Woah, that's new. 

In the returns keyword we specified the name of the returned parameter sum. Then we assigned the x + y to sum inside our function body. The value of sum is implicitly returned.

 Your Goal: Double Uint
Create an external, pure function called double which takes a uint parameter and doubles it. It should return this doubled uint value.

## task 6 


Overloading Functions
In Solidity it is perfectly valid to declare two functions with the same name if they have different parameters:

function add(uint x, uint y) external pure returns(uint) {
    return x + y;
}

function add(uint x, uint y, uint z) external pure returns(uint) {
    return x + y + z;
}
 Solidity will run the function whose signature matches the arguments provided. For example, add(2,4) will invoke the first function while add(2,3,4) will invoke the second function.

Also, Solidity can return multiple values from functions:

function addTwo(uint x, uint y) external pure returns(uint, uint) {
    return (x + 2, y + 2);
}
 Notice that the returns keyword specifies two return values. Also notice that we are wrapping the values in a parenthesis in order to return multiple values. This is referred to as a tuple.

 Tuples are not a formal type in Solidity. They are a list of values that can be used as a temporary structure to return values or do assignment destructuring. The data types of the return values in tuples can be different from each other.

We can also use tuples in assignment destructuring. For example, if we call the function addTwo which we just defined above:

(uint x, uint y) = addTwo(4, 8);
console.log(x); // 6
console.log(y); // 10
 Your Goal: Overload Double
Create another pure external function double which takes two uint parameters.
Double both of the arguments and return both of them in the same order they were passed into the function.
 For this solution, it is possible to use the double function from the previous stage in this solution. You may need to change the visibility from external to public so that you can call it internally as well.


 