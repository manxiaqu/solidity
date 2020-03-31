# storage的变量布局

## 常量

直接硬编码至代码中

## 静态变量

静态变量从index0开始依次存放，当多个连续变量小于32个字节时，则会尝试将其合并存在一个变量中，规则如下：

1. storage slot中的第一个元素以低端对齐方式存储

2. 基本类型只使用必需的字节大小来存储

3. 如果基本类型放入slot剩余的部分，则放入下一个slot

4. struct和array总是新起一个slot，并占据全部slot(内部数据按这些规则排序)

## 动态变量

1. array: 变量声明位置存储了数组v长度, 实际数据存储在keccak256(p) + array index. p为变量位置，index为数组索引

2. mapping: 变量声明位置未使用，实际数据存储在keccak256(k . p); k为key。多级映射时，将上一级的结果作为p重复上述步骤即可

3. bytes/string: 当数据量小于31bytes时，在变量声明位置存储，且低位存储了字符串的长度。当大于时，变量声明位置存储了字符串的长度
实际存储数据从keccak256(p)开始. **字符串数据是左对齐的**

# memory变量布局

solidity保留了4个32字节大小位置用于特殊用途。

1. 0x00 - 0x3f (64 bytes): hash方法暂存空间

2. 0x40 - 0x5f (32 bytes)： 当前内存使用大小

3. 0x60 - 0x7f (32 bytes): zero slot， 用于初始化动态memory数组

# library

1. library的internal方法在编译期间会放入调用它的合约的代码中，使用jump而不是delegatecall调用。