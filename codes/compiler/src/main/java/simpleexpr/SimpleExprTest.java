package simpleexpr;

import org.antlr.v4.runtime.*;
import java.io.File;
import java.io.IOException;

public class SimpleExprTest {
    public static void main(String[] args) {
        String fileName = "simpleexpr0.txt";

        // === 🕵️ 侦探代码开始 ===
        System.out.println("================ 调试信息 ================");
        // 1. 打印当前程序运行在哪个目录下
        System.out.println("程序运行目录 (User Dir): " + System.getProperty("user.dir"));

        // 2. 检查文件是否真的存在
        File file = new File(fileName);
        System.out.println("目标文件路径: " + file.getAbsolutePath());
        System.out.println("文件是否存在? " + (file.exists() ? "✅ 存在！" : "❌ 不存在！"));
        System.out.println("==========================================");
        // === 侦探代码结束 ===

        if (!file.exists()) {
            System.err.println("错误：找不到文件！请检查上面的'程序运行目录'和'目标文件路径'是否一致。");
            return; // 文件不存在就直接结束，防止后面报错
        }

        try {
            CharStream input = CharStreams.fromFileName(fileName);
            SimpleExprLexer lexer = new SimpleExprLexer(input);
            System.out.println("=== 成功读取文件， 开始打印 Token ===");
            lexer.getAllTokens().forEach(System.out::println);

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}