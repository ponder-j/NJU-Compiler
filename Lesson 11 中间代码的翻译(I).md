### 表达式的中间代码翻译
![[Pasted image 20260215104129.png]]
top：当前作用域对应的符号表

### 数组引用的中间代码翻译
![[Pasted image 20260215105638.png]]
![[Pasted image 20260215110419.png]]
另一种不用自己算偏移量的方法：GEP(GetElementPtr)
![[Pasted image 20260215111927.png]]
![[Pasted image 20260215111304.png]]
`i64 0` 按照基础类型的大小，偏移指针量
![[Pasted image 20260215111658.png]]
![[Pasted image 20260215111747.png]]
