const StaticStorage = artifacts.require('StaticStorage');
const { toBN, contact, zero, shortStringLen } = require('./utils');

contract('static-sized variables storage slot ', function(accounts){
        let storage;
        let addr;
        
        before(async function(){
                storage = await StaticStorage.new();
                addr = storage.address;
        })

        describe('normal variable per slot', async function(){
                it('bool', async function(){
                        let var0 = await storage.var0.call();
                        let expect0 = await web3.eth.getStorageAt(addr, 0);
                        // get storage by assembly.
                        let am0 = await storage.assemblyCall(0);

                        assert.equal(expect0, var0, "var 0 not equal");
                        assert.equal(am0, var0, "assembly call var0 not equal");
                })

                it('uint256', async function(){
                        let var1 = await storage.var1.call();
                        let expect1 = await web3.eth.getStorageAt(addr, 1);
                        let am1 = await storage.assemblyCall(1);

                        assert.equal(true, toBN(expect1).eq(var1), "var 1 not equal");
                        assert.equal(true, toBN(am1).eq(var1), "assembly call var1 not equal");
                })

                it('address', async function(){
                        let var2 = await storage.var2.call();
                        let expect2 = await web3.eth.getStorageAt(addr, 2);
                        let am2 = await storage.assemblyCall(2);

                        assert.equal(true, toBN(var2).eq(toBN(expect2)));
                        assert.equal(true, toBN(var2).eq(toBN(am2)));
                })

                it('fixed-size byte arrays', async function(){
                        let var3 = await storage.var3.call();
                        let expect3 = await web3.eth.getStorageAt(addr, 3);
                        let am3 = await storage.assemblyCall(3);

                        assert.equal(true, toBN(var3).eq(toBN(expect3)));
                        assert.equal(true, toBN(var3).eq(toBN(am3)));
                })

                it('pack var into a single slot', async function(){
                        let var5 = await storage.var5.call();
                        let var6 = await storage.var6.call();

                        let expect5 = await web3.eth.getStorageAt(addr, 5);
                        let am5 = await storage.assemblyCall(5);
                        
                        assert.equal(true, contact(var5, var6, 128).eq(toBN(expect5)));
                        assert.equal(true, toBN(expect5).eq(toBN(am5)));
                })
        })

        describe('dynamic types', async function(){
                it('array(byte arrays and strings except)', async function(){
                        let varIndex = 6;
                        // slot storage the len of array.
                        let len = await web3.eth.getStorageAt(addr, varIndex);

                        assert.equal(true, toBN(len).eq(zero));
                        // get array
                        // push items to array and check len of array.
                        let item = 10;
                        await storage.push(item);
                        len = await web3.eth.getStorageAt(addr, varIndex);
                        assert.equal(true, toBN(len).eq(new toBN('1')));

                        let acItem = await storage.getArray(varIndex, 0);
                        assert.equal(toBN(acItem).toNumber(), item);
                })

                it('mapping', async function(){
                        let itemIndex = 10;
                        let itemValue = 11;

                        await storage.setMapping(itemIndex, itemValue);
                        let v = await storage.getMapping(itemIndex);
                        assert.equal(itemValue, toBN(v).toString());
                })

                it('bytes and string', async function(){
                        // short string
                        let var9 = await storage.var9.call();
                        let v = await storage.assemblyCall(8);
                        let len = toBN(shortStringLen(v));
                        assert.equal(len.toNumber(), 2*var9.length);

                        // long string.
                        let var10 = await storage.var10.call();
                        let len10 = await storage.assemblyCall(9);
                        assert.equal(toBN(len10).toNumber(), 2*var10.length+1);
                })
        })
})