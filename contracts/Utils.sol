pragma solidity ^0.6.0;


contract Utils {
	// check s1 equals s2 or not
	function equals(string memory s1, string memory s2)
		public
		pure
		returns (bool res)
	{
		assembly {
			let s1size := mload(s1)
			let s2size := mload(s2)
			if eq(s1size, s2size) {
				for {
					let i := 0
				} lt(i, s2size) {
					i := add(i, 0x20)
				} {
					let s1c := mload(add(s1, add(0x20, i)))
					let s2c := mload(add(s2, add(0x20, i)))
					if eq(0, eq(s1c, s2c)) {
						mstore(res, 0x0)
						return(res, 0x20)
					}
				}
				mstore(res, 0x1)
				return(res, 0x20)
			}

			mstore(res, 0x0)
			return(res, 0x20)
		}
	}
}
