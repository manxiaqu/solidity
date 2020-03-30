pragma solidity ^0.5.0;

// Static variables storage layout.
contract StaticStorage {
        bool public var0 = false;
        uint public var1 = 100;

        function assemblyCall(uint index) public view {
                bool c = var0;
                require(c);
        }
}