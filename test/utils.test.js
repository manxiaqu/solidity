const Utils = artifacts.require('Utils');

contract('utils', function (accounts) {
    let utils;
    before(async function () {
        utils = await Utils.new();
    })

    it("string equals", async function () {
        let s1 = "s1";
        let s2 = "s2";

        let res = await utils.equals(s1, s2);
        assert.equal(false, res);

        s1 = "ccccdddddeeeeessss";
        s2 = "ccccdddddeeeeessss";
        res = await utils.equals(s1, s2);
        assert.equal(true, res);

        s1 = "ccccdddddeeeeessss";
        s2 = "bcccdddddeeeeessss";
        res = await utils.equals.call(s1, s2);
        assert.equal(false, res);
    })
})