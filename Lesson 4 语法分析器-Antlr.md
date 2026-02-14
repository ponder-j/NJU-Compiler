### 语法分析器、二义性

为什么 `expr '[' expr ']'` 能够表示二维数组或多维数组？
递归：
![[Pasted image 20260204223614.png]]

问题：如何解决文法的二义性(ambiguous)

eg1.
![[Pasted image 20260204224043.png]]

方法一（非常麻烦，看不懂）：
![[Pasted image 20260204224119.png]]

antlr 的解决方式：
最前优先匹配原则，如果能先匹配到前面的形式，就不去匹配后面的形式。
结果：else 只匹配离它最近的没被匹配的 if，程序不会出现二义性，上面的代码不用改。

eg2.
![[Pasted image 20260204224638.png]]
antlr 的解决方式：默认全部左结合。
手动指定右结合：
![[Pasted image 20260204224750.png]]
eg3.
![[Pasted image 20260205110011.png]]
antlr 的解决方式：仍然是最前优先匹配原则，写在前面的优先级高。
其他方法：
![[Pasted image 20260205110522.png]]
坏处：会造成非终结符个数的极大膨胀；增加过多无用的结点；造成代码理解的困难。
实现原理：`expr : expr '-' term | term;` 利用左递归表达多个 term 相减，每个 term 同样利用左递归表达多个 factor 相乘，因此乘法的优先级必然高于减法。
右递归可以吗？
![[Pasted image 20260205111149.png]]
把 `1-2-3` 也右结合了，但大多数二元运算符都是左结合的。
![[Pasted image 20260205111306.png]]


### 生成函数调用图

Antlr 4 已经帮我们生成了语法分析树 (parse/syntax tree)，这一块怎么实现的在下一节中讲。

ParseTreeWalker 负责以 DFS 方式自动遍历语法树
每个结点至少经过两遍：第一次发现这个结点：Enterxxx；第二次遍历完所有该结点下的子节点，以后再也不来：Exitxxx

Antlr 4 允许我们在这两次时刻注册监听器
Antlr 4 允许我们在每个展开的可能性中加上标签，这样在监听的时候就能知道是按什么规则展开的了，也不需要写 if 语句。且如果你为其中一个事件加标签的话，你需要把这条规则下的所有事件都加上标签。

```antlr
expr: ID '(' exprList? ')'    # Call // function call  
    | expr '[' expr ']'       # Index // array subscripts  
    | op = '-' expr                # Negate // right association  
    | op = '!' expr                # Not // right association  
    | <assoc = right> expr '^' expr # Power  
    | lhs = expr (op = '*' | op = '/') rhs = expr     # MultDiv  
    | lhs = expr (op = '+' | op = '-') rhs = expr     # AddSub  
    | lhs = expr (op = '==' | op = '!=') rhs = expr  # EQNE  
    | '(' expr ')'            # Parens  
    | ID                      # Id  
    | INT                     # Int  
    ;
```

lhs: left hand side
rhs: right hand side
用于区分左右子树，避免使用下标去访问（不直观）
op 使得我们能够拿到具体的运算符

点击 Gradle 中的 generateGrammarSource
CymbolBaseListener 中是 Antlr 提供的默认悬空实现
我们在 `java/cymbol.callgraph/FunctionCallGraphListener.java` 中对其进行扩展：
```java
  private String currentFunction;  
  
  @Override  
  public void enterFunctionDecl(CymbolParser.FunctionDeclContext ctx) {  
    currentFunction = ctx.ID().getText();  
    graph.addNode(currentFunction);  
  }  
  
  @Override  
  public void enterCall(CymbolParser.CallContext ctx) {  
    String callee = ctx.ID().getText();  
    graph.addEdge(currentFunction, callee);  
  }  
}
```
核心代码只有 5 行，即可利用监听机制画出函数调用的关系图