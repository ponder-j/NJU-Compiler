### 类型检查 Type Checking

强类型语言 vs 弱类型语言
动态类型语言 vs 静态类型语言

### 符号检查 Symbols Checking

符号：变量名、函数名、类型名、标签名 etc

eg. 变量未定义无法在语法分析中检查出来，因为它是上下文相关的

![[Pasted image 20260213101050.png]]

符号表：用于保存各种符号相关信息的数据结构

实现难点：作用域（通用程序设计语言 GPL 通常需要嵌套作用域）
作用域树

![[Pasted image 20260213101558.png]]
C 语言中函数的形参声明和函数体其实是一个作用域，上课时分成两个作用域。

![[Pasted image 20260213101829.png]]
外部作用域：父作用域，若在当前作用域中没检查到变量的定义，则还需要到父作用域中去寻找。

![[Pasted image 20260213102244.png]]

全局作用域需要首先放入类型符号

### 代码设计

进出作用域
```antlr
block : '{' stat* '}' ;
```

定义符号
```antlr
stat : ...
     | varDecl  # VarDeclStat
     ...;
```

使用符号
```antlr
expr: ID '(' exprList? ')'    # Call // function call  
    ...
    | ID                      # Id  
	...;
```

最重要的两个动作：看到一个新符号——加入符号表；使用一个符号——解析符号。
```java
public void define(Symbol symbol) {  
  this.symbols.put(symbol.getName(), symbol);  
  System.out.println("+" + symbol);  
}  

public Symbol resolve(String name) {  
  Symbol symbol = this.symbols.get(name);  // 当前作用域中找
  if (symbol != null) {  
    System.out.println("-" + name);  
    return symbol;  
  }  
  
  if (this.enclosingScope != null) {  // 当前不是全局作用域
    return this.enclosingScope.resolve(name);  // 递归到父作用域寻找
  }  
  
  System.out.println("?" + name);  
  return null;  
}
```
![[Pasted image 20260213103531.png]]
定义作用域
```java
@Override  
public void enterProg(CymbolParser.ProgContext ctx) {  // 进入主程序
  globalScope = new GlobalScope(null);  // 定义全局作用域
  this.currentScope = globalScope;  // 指向全局作用域
}  
  
@Override  
public void enterBlock(CymbolParser.BlockContext ctx) {  // 进入 block
  LocalScope localScope = new LocalScope(currentScope);  // 定义新的局部作用域
  graph.addEdge(localScope.getName(), currentScope.getName());  // 添加指向父作用域的边  
  currentScope = localScope;  // 指向当前的局部作用域
}  
  
@Override  
public void enterFunctionDecl(CymbolParser.FunctionDeclContext ctx) { // 进入函数 
  String funcName = ctx.ID().getText();  // 拿到函数名
  FunctionSymbol scope = new FunctionSymbol(funcName, currentScope); // 定义新的函数作用域 
  graph.addEdge(scope.getName(), currentScope.getName());  // 添加父子关系
  
  currentScope.define(scope);  // function 比较特殊，需要放入当前作用域的符号表中
  this.currentScope = scope;  // 进入函数
  // 还需要完成对函数返回值类型的检查分析
}
```
定义符号：
```java
@Override  
public void exitVarDecl(CymbolParser.VarDeclContext ctx) {  
  String typeName = ctx.type().getText();  
  Type type = (Type) this.currentScope.resolve(typeName);  // 解析类型
  
  String varName = ctx.ID().getText();  // 获取变量名字
  
  VariableSymbol varSymbol = new VariableSymbol(varName, type);  // 写入符号表
  this.currentScope.define(varSymbol);  
}  
  
@Override  
public void exitFormalParameter(CymbolParser.FormalParameterContext ctx) {  
  String typeName = ctx.type().getText();  
  Type type = (Type) this.currentScope.resolve(typeName);  
  
  String varName = ctx.ID().getText();  
  
  VariableSymbol varSymbol = new VariableSymbol(varName, type);  
  this.currentScope.define(varSymbol);  
}
```
使用符号：
```java
@Override  
public void exitId(CymbolParser.IdContext ctx) {  
  String varName = ctx.ID().getText();  
  this.currentScope.resolve(varName);  
}
```
退出当前作用域，返回到父作用域：
```java
  @Override  
  public void exitProg(CymbolParser.ProgContext ctx) {  
    graph.addNode(SymbolTableTreeGraph.toDot(currentScope));  
    currentScope = this.currentScope.getEnclosingScope();  
  }  
  
  @Override  
  public void exitBlock(CymbolParser.BlockContext ctx) {  
    graph.addNode(SymbolTableTreeGraph.toDot(currentScope));  
    currentScope = this.currentScope.getEnclosingScope();  
  }  
  
  @Override  
  public void exitFunctionDecl(CymbolParser.FunctionDeclContext ctx) {  
    graph.addNode(SymbolTableTreeGraph.toDot(currentScope));  
    currentScope = this.currentScope.getEnclosingScope();  
  }  
  
  public SymbolTableTreeGraph getGraph() {  
    return graph;  
  }  
}
```

支持结构体？ struct / class
结构体变量.结构体成员

![[Pasted image 20260213200533.png]]
![[Pasted image 20260213200540.png]]
![[Pasted image 20260213201005.png]]
