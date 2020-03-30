pragma solidity ^0.5.0;

// Static variables storage layout.
contract StaticStorage {
        // static variables.
        bool public var0 = true;
        uint public var1 = 2;
        address public var2 = address(3);
        bytes16 public var3 = "4";
        uint private split;
        uint128 public var5 = 5;
        uint128 public var6 = 6;

        // dynamic variables.
        uint[] public var7;
        // keccak256(k . p);
        // k => key. p => position index of variables.
        mapping(uint => uint) var8;

        string public var9 = "short string";
        string public var10 = "this is a long string, ---------------------------------------------------------------";

        function push(uint d) public {
                var7.push(d);
        }

        function setMapping(uint index, uint v) public {
                var8[index] = v;
        }

        function getMapping(uint index) public view returns(bytes32) {
                bytes32 hash = keccak256(abi.encodePacked(index, uint256(7)));
                
                return assemblyCall(uint(hash));
        }

        function getArray(uint variableIndex, uint offset) public view returns(bytes32) {
                bytes32 hash = keccak256(abi.encodePacked(variableIndex));
                uint index = uint(hash) + offset;

                return assemblyCall(index);
        }

        function assemblyCall(uint index) public view returns(bytes32 r) {
                assembly {
                        r := sload(index)
                }
        }
}