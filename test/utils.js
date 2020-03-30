const { BN } = require('@openzeppelin/test-helpers');

exports.toBN = function(hex) {
        return tobn(hex);
}

exports.zero = new BN('0');

// 0x000(second)000(first).
exports.contact = function(first, second, size) {
        let mid = new BN('2').pow(new BN(size.toString()));
        return second.mul(mid).add(first);
}

exports.shortStringLen = function(bytes) {
        return bytes.substring(bytes.length-2, bytes.length);
}

function tobn(hex) {
        if (hex.startsWith('0x') || hex.startsWith('0X')) {
                hex = hex.substring(2, hex.length);
        }

        return new BN(hex.replace(/\b(0+)/gi,""), 16);
}