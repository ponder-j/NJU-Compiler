![[Pasted image 20260213212939.png]]
你关心什么，什么就是语义。

**综合属性**
**继承属性**


![[Pasted image 20260213233042.png]]
用这种方式计算属性值——添加返回值！

Antlr 4 文件中嵌入 Java 代码：
![[Pasted image 20260213233018.png]]

继承属性 inherit
![[Pasted image 20260214002421.png]]
三种依赖：1. 父节点属性值依赖子节点（上面已经实现）；2. 兄弟结点之间有依赖（根据规则 4，右依赖左）；3. 子节点对父节点的依赖（从右上传导到左下）

解决 2 3 两种依赖——添加参数！
通过参数的传递实现依赖值的传递
![[Pasted image 20260214004318.png]]
但是 antlr 4 不支持这种写法（）
使用克林闭包的写法：
![[Pasted image 20260214004517.png]]




![[Pasted image 20260214005836.png]]

![[Pasted image 20260214005926.png]]
![[Pasted image 20260214005939.png]]

![[Pasted image 20260214010059.png]]
综合属性：
![[Pasted image 20260214010140.png]]
![[Pasted image 20260214010156.png]]
![[Pasted image 20260214010248.png]]


继承属性：
![[Pasted image 20260214010405.png]]
加强的定义：
![[Pasted image 20260214010519.png]]
这样就不用考虑左兄弟依赖右兄弟的情形了

后缀表达式：
![[Pasted image 20260214010731.png]]

![[Pasted image 20260214124456.png]]

![[Pasted image 20260214131623.png]]
每遇到一个 `[]` 都要剥离一层类型（例如一个二维数组 `a[3][6]` 的类型是 `(3,(6,int))` ）
![[Pasted image 20260214175003.png]]
![[Pasted image 20260214174603.png]]
![[Pasted image 20260214174743.png]]

“分离式”——Offline，g4（文法） 和 java（额外执行的操作） 代码分离，写起来清爽，代价是要先构建语法分析树，导致至少遍历两遍；
“嵌入式”——Online，建立树的同时进行分析，减少树的遍历次数，代价是写起来容易绕晕
![[Pasted image 20260214175431.png]]
取两者之长：
![[Pasted image 20260214175526.png]]
缺点：限制大


![[Pasted image 20260214181540.png]]
![[Pasted image 20260214181558.png]]
SDT 是 SDD 的一个实现
![[Pasted image 20260214182037.png]]
