pragma solidity ^0.6.0;
import "./library/Lib.sol";


// Static variables storage layout.
contract StaticStorage {
	// static variables.
	bool public var0 = true;
	uint256 public var1 = 2;
	address public var2 = address(3);
	bytes16 public var3 = "4";
	uint256 private split;
	uint128 public var5 = 5;
	uint128 public var6 = 6;

	// dynamic variables.
	uint256[] public var7;
	// keccak256(k . p);
	// k => key. p => position index of variables.
	mapping(uint256 => uint256) var8;

	string public var9 = "short string";
	string public var10 = "this is a long string, ---------------------------------------------------------------";

	function push(uint256 d) public {
		var7.push(d);
	}

	function setMapping(uint256 index, uint256 v) public {
		var8[index] = v;
	}

	function getMapping(uint256 index) public view returns (bytes32) {
		bytes32 hash = keccak256(abi.encodePacked(index, uint256(7)));

		return assemblyCall(uint256(hash));
	}

	function getArray(uint256 variableIndex, uint256 offset)
		public
		view
		returns (bytes32)
	{
		bytes32 hash = keccak256(abi.encodePacked(variableIndex));
		uint256 index = uint256(hash) + offset;

		return assemblyCall(index);
	}

	function assemblyCall(uint256 index) public view returns (bytes32 r) {
		assembly {
			r := sload(index)
		}
	}

	function at(address _addr)
		public
		view
		returns (bytes memory o_code, bytes32 len)
	{
		assembly {
			// retrieve the size of the code, this needs assembly
			let size := extcodesize(_addr)
			// allocate output byte array - this could also be done without assembly
			// by using o_code = new bytes(size)
			// o_code = mem[0x40-(0x40+0x20)]; current mem position. the mem is starting at 0x80.
			o_code := mload(0x40)
			// new "memory end" including padding
			// and(add(add(size, 0x20), 0x1f), not(0x1f))): ensure the mem size is multiple
			// relaionship with 0x20.
			mstore(
				0x40,
				add(o_code, and(add(add(size, 0x20), 0x1f), not(0x1f)))
			)
			// store length in memory
			mstore(o_code, size)
			len := mload(o_code)
			// actually retrieve the code, this needs assembly
			// extcodecopy(a:u256, t:u256, f:u256, s:u256): copy s bytes from code at a to mem at position t.
			extcodecopy(_addr, add(o_code, 0x20), 0, size)
		}
	}

	function helloWorld() public pure returns (string memory word) {
		assembly {
			word := mload(0x40)
			// allocate output string. 0x40 in total.
			// 0x20 => size. 0x20 => actual data(hello world).
			mstore(0x40, add(word, 0x40))
			// len of "hello world".
			mstore(word, 0xb)
			// 0x68656c6c6f20776f726c64000000000000000000000000000000000000000000 is the bytes hex format of "hello world".
			// Strings are stored left-aligned.
			mstore(
				add(word, 0x20),
				0x68656c6c6f20776f726c64000000000000000000000000000000000000000000
			)
		}
	}

	function getLibrary() public pure returns (string memory) {
		return Lib.hello();
	}
}
