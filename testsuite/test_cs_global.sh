#!/bin/bash

# test the collection of global variable names in c#

cat <<EOF > test_global.cs
using System;

public class Globals {
    public static int BUF = 123;
    public static string name = "name string";
    public static int[] array = {1,2,3}; 
}

class Program {
    static int GlobalVar = 12; 
    static void Main() {
        Console.Write(GlobalVar);
        int localInt = 456;
    }
}
EOF

input=$(srcml test_global.cs --position)
output=$(echo "$input" | ./nameCollector )
expected="Globals is a class in C# file: test_global.cs:3:14
BUF is a public static int field in C# file: test_global.cs:4:23
name is a public static string field in C# file: test_global.cs:5:26
array is a public static int[] field in C# file: test_global.cs:6:25
Program is a class in C# file: test_global.cs:9:7
GlobalVar is a static int field in C# file: test_global.cs:10:16
Main is a static void function in C# file: test_global.cs:11:17
localInt is a int local in C# file: test_global.cs:13:13"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cs_global failed!"
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_cs_global passed!"
# Repeat tests

exit 0
