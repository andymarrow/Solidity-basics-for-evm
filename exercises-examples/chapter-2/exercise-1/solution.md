# SENDING ETHER
## solution to 1

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Contract {
    address public owner;

    constructor() {
        owner = msg.sender;
    }
}

![alt text](image.png)

## solution to 2

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Contract {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // Allows the contract to receive Ether with empty calldata
    receive() external payable {
    }
}

![alt text](image-1.png)

## solution to 3

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Contract {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function tip() public payable {
        (bool success, ) = owner.call{value: msg.value}("");
        require(success);
    }
}

so in trying this i got this error so i tried to fix it

![alt text](image-2.png)

but technically my code is right 

The test is failing due to forwarding method + execution expectation mismatch

i check validation and it seem fine 

![alt text](image-3.png)


then i checked the solution and as you can see its similar i dont know why were getting this error hmmm , let me just replace it and try but it seem like a same code for me 

![alt text](image-4.png)


well for some reason this new solution worked weird 

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Contract {
	address public owner;

	constructor() {
		owner = msg.sender;
	}

	receive() external payable { }

	function tip() public payable {
		(bool success, ) = owner.call{ value: msg.value }("");
		require(success);
	}
}

![alt text](image-5.png)

## solution to 4

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Contract {
    address public owner;
    address public charity;

    constructor(address _charity) {
        owner = msg.sender;
        charity = _charity;
    }

    receive() external payable {}

    function donate() public {
        payable(charity).transfer(address(this).balance);
    }
}

![alt text](image-6.png)


## solution to 5


contract Contract {
    address public owner;
    address public charity;

    constructor(address _charity) {
        owner = msg.sender;
        charity = _charity;
    }

    receive() external payable {}

    function donate() public {
        selfdestruct(payable(charity));
    }
}


![alt text](image-7.png)


# LEARNING REVERT

## solution to 1

contract Contract {
    address public owner;

    constructor() payable {
        require(msg.value >= 1 ether, "Must send at least 1 ether");
        owner = msg.sender;
    }
}

![alt text](image-8.png)


## solution to 2

contract Contract {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function withdraw() public {
        require(msg.sender == owner, "Not owner");
        payable(owner).transfer(address(this).balance);
    }
}


i tried this solution and it didnt work 

![alt text](image-9.png)


so i tried to fix that with this code 

contract Contract {
    address public owner;

    constructor() payable {
        require(msg.value >= 1 ether, "Not enough ETH");
        owner = msg.sender;
    }

    function withdraw() public {
        require(msg.sender == owner, "Not owner");
        payable(owner).transfer(address(this).balance);
    }
}

and this solution has worked 

![alt text](image-10.png)

## solution to 3

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Contract {
	uint configA;
	uint configB;
	uint configC;
	address owner;

	constructor() {
		owner = msg.sender;
	}

	function setA(uint _configA) public onlyOwner {
		configA = _configA;
	}

	function setB(uint _configB) public onlyOwner {
		configB = _configB;
	}

	function setC(uint _configC) public onlyOwner {
		configC = _configC;
	}

	modifier onlyOwner {
    require(msg.sender == owner, "Not owner");
    _;
}
}

![alt text](image-11.png)


# CALLDATA

## solution to 1

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IHero {
    function alert() external;
}

contract Sidekick {
    function sendAlert(address hero) external {
        IHero(hero).alert();
    }
}


![alt text](image-12.png)

## solution to 2

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Sidekick {
    function sendAlert(address hero) external {
        bytes4 signature = bytes4(keccak256("alert()"));

        (bool success, ) = hero.call(abi.encodePacked(signature));

        require(success);
    }
}

![alt text](image-13.png)

## solution to 3


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Sidekick {
    function sendAlert(address hero, uint enemies, bool armed) external {
        (bool success, ) = hero.call(
            abi.encodeWithSignature(
                "alert(uint256,uint256,bool)",
                enemies,
                enemies,
                armed
            )
        );

        require(success);
    }
}


in tring this i got this error 

![alt text](image-14.png)

the fix was 

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Sidekick {
    function sendAlert(address hero, uint enemies, bool armed) external {
        (bool success, ) = hero.call(
            abi.encodeWithSignature("alert(uint256,bool)", enemies, armed)
        );

        require(success);
    }
}

![alt text](image-15.png)




## solution to 4


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Sidekick {
    function relay(address hero, bytes memory data) external {
        (bool success, ) = hero.call(data);

        require(success);
    }
}

![alt text](image-16.png)

## solution to 5


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Sidekick {
    function makeContact(address hero) external {
        // send over any calldata that doesnt match existing signatures!
        (bool success, ) = hero.call(
            abi.encodeWithSignature("")
        );

        require(success);
    }
}

![alt text](image-17.png)


# ESCROW

## solution to 1

// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Escrow {
	address public arbiter;
	address public beneficiary;
	address public depositor;
	
}

![alt text](image-18.png)


## solution to 2

// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Escrow {
	address public arbiter;
	address public beneficiary;
	address public depositor;

	constructor(address _arbiter, address _beneficiary) {
		arbiter = _arbiter;
		beneficiary = _beneficiary;
		depositor = msg.sender;
	}
}


![alt text](image-19.png)


## solution to 3

// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Escrow {
	address public arbiter;
	address public beneficiary;
	address public depositor;

	constructor(address _arbiter, address _beneficiary) payable {
		arbiter = _arbiter;
		beneficiary = _beneficiary;
		depositor = msg.sender;
	}
}


![alt text](image-20.png)

## solution to 4


// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Escrow {
	address public arbiter;
	address public beneficiary;
	address public depositor;

	constructor(address _arbiter, address _beneficiary) payable {
		arbiter = _arbiter;
		beneficiary = _beneficiary;
		depositor = msg.sender;
	}

	function approve() external {
		(bool success, ) = beneficiary.call{ value: address(this).balance }("");
		require(success);
	}
}

![alt text](image-21.png)

## solution to 5


// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Escrow {
	address public arbiter;
	address public beneficiary;
	address public depositor;

	constructor(address _arbiter, address _beneficiary) payable {
		arbiter = _arbiter;
		beneficiary = _beneficiary;
		depositor = msg.sender;
	}

	error NotAuthorized();

	function approve() external {
		if(msg.sender != arbiter) revert NotAuthorized();
		
		(bool success, ) = beneficiary.call{ value: address(this).balance }("");
		require(success);
	}
}

![alt text](image-22.png)

## solution to 6

// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Escrow {
	address public arbiter;
	address public beneficiary;
	address public depositor;

	constructor(address _arbiter, address _beneficiary) payable {
		arbiter = _arbiter;
		beneficiary = _beneficiary;
		depositor = msg.sender;
	}

	event Approved(uint);
	
	error NotAuthorized();

	function approve() external {
		if(msg.sender != arbiter) revert NotAuthorized();

		uint balance = address(this).balance;

		(bool success, ) = beneficiary.call{ value: balance }("");
		require(success);
		
		emit Approved(balance);
	}
}

![alt text](image-23.png)