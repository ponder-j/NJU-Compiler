![[Pasted image 20260203001729.png]]

算法核心：
![[Pasted image 20260203015445.png]]
第一类：
WS, ID, INT 三种词法单元的识别
![[Pasted image 20260203020937.png]]

``` java
Token token = null;  
if (Character.isWhitespace(peek)) {  
  token = WS();  
} else if (Character.isLetter(peek)) {  
  token = ID();  
} else if (Character.isDigit(peek)) {  
  token = INT();  
}

...

private Token WS() {  
  while (Character.isWhitespace(peek)) {  
    advance();  
  }  
  
  return Token.WS;  
}  
  
private Token ID() {  
  StringBuilder sb = new StringBuilder();  
  
  do {  
    sb.append(peek);  
    advance();  
  } while (Character.isLetterOrDigit(peek));  
  // 去关键字表里面查 sb，如果查到了就返回关键字，没查到就说明是个普通的 ID
  Token token = kwTable.getKeyword(sb.toString());  
  if (token == null) {  
    return new Token(TokenType.ID, sb.toString());  
  }  
  return token;  
}

private Token INT() {  
  StringBuilder sb = new StringBuilder();  
  
  do {  
    sb.append(peek); // 吃掉当前数字  
    advance();       // 往后移一位  
  } while (Character.isDigit(peek)); // 只要还是数字(digit)，就继续在 State 13 循环  
  
  return new Token(TokenType.INT, sb.toString());  
}
```

![[Pasted image 20260204153358.png]]

第二类：
![[Pasted image 20260204153442.png]]
第三类：
目标：识别 3 类 NUMBER，int real sci
![[Pasted image 20260204181605.png]]
![[Pasted image 20260204181844.png]]

模拟状态转移图：switch case 进行转移
```java
private Token NUMBER() {  
  int state = 13;  
  advance();  
  
  while (true) {  
    switch (state) {  
      case 13:  
        longestValidPrefixPos = pos;  
        longestValidPrefixType = TokenType.INT;  
  
        if (Character.isDigit(peek)) {  
          advance();  
        } else if (peek == '.') {  
          state = 14;  
          advance();  
        } else if (peek == 'E' || peek == 'e') {  
          state = 16;  
          advance();  
        } else {  
          return backToLongestMatch();  
        }  
        break;  
      case 14:  
        if (Character.isDigit(peek)) {  
          state = 15;  
          advance();  
        } else {  
          return backToLongestMatch();  
        }  
        break;  
      case 15:  
        longestValidPrefixPos = pos;  
        longestValidPrefixType = TokenType.REAL;  
  
        if (Character.isDigit(peek)) {  
          advance();  
        } else if (peek == 'E' || peek == 'e') {  
          state = 16;  
          advance();  
        } else {  
          return backToLongestMatch();  
        }  
        break;  
      case 16:  
        if (peek == '+' || peek == '-') {  
          state = 17;  
          advance();  
        } else if (Character.isDigit(peek)) {  
          state = 18;  
          advance();  
        } else {  
          return backToLongestMatch();  
        }  
        break;  
      case 17:  
        if (Character.isDigit(peek)) {  
          state = 18;  
          advance();  
        } else {  
          return backToLongestMatch();  
        }  
        break;  
      case 18:  
        longestValidPrefixPos = pos;  
        longestValidPrefixType = TokenType.SCI;  
  
        if (Character.isDigit(peek)) {  
          advance();  
        } else {  
          return backToLongestMatch();  
        }  
        break;  
      default:  
        System.err.println("Unreachable");  
    }  
  }  
}
```
这些状态一共可以分成 3 类：
![[Pasted image 20260204201223.png]]
故需要一个变量用于记录当前最长成功匹配的位置，同时记录这个合法 token 的类型：
```java
private int longestValidPrefixPos = 0;
private TokenType longestValidPrefixType = null;
```
除此之外还需要有一个标记“最后一次成功匹配后的位置”，这个值 +1 就是新一轮 token 的起点位置。
```java
private int lastMatchPos = 0;
```
它只在成功匹配后更新(case 13,15,18).

处理 14, 16, 17 的回退：
```java
private Token backToLongestMatch() {  
  Token token = new Token(longestValidPrefixType,  
      input.substring(lastMatchPos, longestValidPrefixPos));  
  
  System.out.println(lastMatchPos + ":" + (longestValidPrefixPos - 1));  
  
  if (longestValidPrefixPos < input.length()) {  
    this.reset(longestValidPrefixPos);  
  }  
  
  return token;  
}
```
并且 13, 15, 18 的 else 情况同样可以看作“失败需要回退”，因此也可以调用这个函数来解决，代码更简洁干净。
```java
case 13:  
  longestValidPrefixPos = pos;  
  longestValidPrefixType = TokenType.INT;  
  
  if (Character.isDigit(peek)) {  
    advance();  
  } else if (peek == '.') {  
    state = 14;  
    advance();  
  } else if (peek == 'E' || peek == 'e') {  
    state = 16;  
    advance();  
  } else {  
    return backToLongestMatch();  
  }  
  break;
```
