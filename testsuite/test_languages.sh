#!/bin/bash

# Works for C, C++, C#, and Java
# assure files in each language are properly identified as such

cat <<EOF > test_cpp.cpp
#include <iostream>
int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
EOF

cat <<EOF > test_c.c
#include <stdio.h>
int main() {
    printf("Hello, World!\n");
    return 0;
}
EOF

cat <<EOF > test_cs.cs
using System;
class Program{
    static void CSmain(string[] CSargs){
        Console.WriteLine("Hello World!");
    }
}
EOF

cat <<EOF > test_java.java
public class HelloWorld {
    public static void Jmain(String[] Jargs) {
        System.out.println("Hello, World!");
    }
}
EOF

input=$(srcml test_cpp.cpp test_c.c test_cs.cs test_java.java --position)
output=$(echo "$input" | ./nameCollector )
expected="main is a int function in C++ file: test_cpp.cpp at 2:5
main is a int function in C file: test_c.c at 2:5
Program is a class in C# file: test_cs.cs at 2:7
CSmain is a static void function in C# file: test_cs.cs at 3:17
CSargs is a string[] parameter in C# file: test_cs.cs at 3:33
HelloWorld is a class in Java file: test_java.java at 1:14
Jmain is a public static void function in Java file: test_java.java at 2:24
Jargs is a String[] parameter in Java file: test_java.java at 2:39"

# passes if all languages are collected properly
# fails if one or more language is incorrectly collected
if [[ "$output" != "$expected" ]]; then
    echo "Test test_languages failed!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
echo "Test test_languages passed!"
# Repeat tests

exit 0