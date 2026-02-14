![[Pasted image 20260212021539.png]]
### LL(1) 语法分析器

#### 自顶向下的

根节点是文法的起始符号 `S`
每个中间节点表示对某个非终结符应用某个产生式进行推导
（关键问题：选择哪个非终结符，选择哪个产生式）
叶节点是词法单元流 `w$`

Q1: 选择哪个非终结符？
最左边的(leftmost)
Left-to-right(从左向右读入词法单元) Leftmost(每次选择最左边的非终结符进行展开)

Q2: 选择哪个产生式？
预测分析表

#### 递归下降的

![[Pasted image 20260212022415.png]]
![[Pasted image 20260212023048.png]]

#### 基于预测分析表的

![[Pasted image 20260212023738.png]]
![[Pasted image 20260212023805.png]]
LL(1) 中的 1 就表示只需要看当前的一位就能知道应该匹配哪条产生式
![[Pasted image 20260212024238.png]]
关键：如何构建预测分析表

**First Set** : 一个非终结符展开后能得到的第一个终结符的集合
![[Pasted image 20260212152822.png]]
![[Pasted image 20260212153216.png]]

算法：
1. 求 FIRST(X)
![[Pasted image 20260212154518.png]]
不断应用上述规则，直到每个 First(X) 都不再变化（即不动点
![[Pasted image 20260212154627.png]]
2. 求 FOLLOW(X)
![[Pasted image 20260212190542.png]]
3. 填表
![[Pasted image 20260212190814.png]]
这两条规则也可以写成：
![[Pasted image 20260212190920.png]]

#### 适用于 LL(1) 文法的
![[Pasted image 20260212190836.png]]

例子：
![[Pasted image 20260212191017.png]]

### 总结
![[Pasted image 20260212191100.png]]

![[Pasted image 20260212191307.png]]
![[Pasted image 20260212191359.png]]
