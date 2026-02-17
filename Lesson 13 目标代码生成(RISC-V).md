riscv 基础语法
数组操作
分支
循环

函数调用
跳转 max 函数：
```assembly
jal ra, max # jal: jump and link (link: ra(约定) <- pc+4; pc <- &max)
# 也可以写成 jal max（4 Bytes）
# 还可以写成 call max（8 Bytes，实际上是两条指令）
```
从 max 函数返回：
```assembly
jalr zero 0(ra) # jalr: jump and link register(offset) (link: rd <- pc+4)
# 也可以写成 jr ra
# 还可以写成 ret
```
这里写 zero 意味着 pc + 4 无法写入一个值恒为 0 的寄存器中，即实现只做 jump 不做 link.

```assembly
.globl main # 声明全局变量，并勾选（模拟器设置），使得 pc 初始化在 main 处
```

堆栈
sp：stack pointer
栈从高地址向低地址生长
