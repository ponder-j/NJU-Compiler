grammar SimpleExpr;

// 连接 ANTLR 语法定义 和 Java 项目结构 的桥梁
//@header {
//package simpleexpr;
//}

// 语法规约（名字都小写）
// 最抽象的一层结构：程序由若干 statement 构成
prog : stat* EOF ;
// 下一层，stat 有几种基本结构
stat : expr ';'
     | ID '=' expr ';'
     | 'print' expr ';'
     ;
expr : expr ('*' | '/') expr // 括号括起来的叫子规则
     | expr ('+' | '-') expr // 优先级比乘除低
     | '(' expr ')'
     | ID
     | INT
     | FLOAT
     ;

// 词法规约（名字全大写）
// antlr 4 会自动将前面出现的 "print" ";" 等关键字列为独立的词法单元
// 也可以右击 -> 生成 显式地插入
SEMI : ';' ;
ASSIGN : '=' ;
PRINT : 'print' ;
MUL : '*' ;
DIV : '/' ;
ADD : '+' ;
SUB : '-' ;
LPAREN : '(' ;
RPAREN : ')' ;

ID : ('_' | LETTER) WORD* ;
// 下面的 ? 表示匹配 0 次或 1 次
INT : '0' | ('+' | '-')? [1-9]NUMBER* ;
FLOAT : INT '.' NUMBER*
      | '.' NUMBER+
      ;
// doc comment 必须写在多行注释前面！否则会被直接识别成多行注释
DOCS_COMMENT : '/**' .*? '*/' -> skip;
// 单行注释(antlr 中的 . 也会匹配换行符，故需要使用 ? 即非贪婪匹配，遇到最短的符合要求的就停下来)
SL_COMMENT : '//' .*? '\n' -> skip;
// 另一种不用非贪婪匹配的写法
SL_COMMENT2 : '//' (~'\n')* '\n' -> skip;
// 多行注释
ML_COMMENT : '/*' .*? '*/' -> skip;
// white space 重要，识别到就扔掉
WS : [ \t\r\n]+ -> skip ;

// 定义一个辅助的规则，简化上面的编写
fragment LETTER : [a-zA-Z] ;
fragment NUMBER : [0-9] ;
fragment WORD : '_' | LETTER | NUMBER ;