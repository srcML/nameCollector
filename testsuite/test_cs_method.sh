#!/bin/bash

# test the collection of method names in c sharp

cat <<EOF > test_method.cs
using System;

class Program {
    static int add(int a, int b){
        return a+b; 
    }

    void nonStaticFunction(){
        Console.WriteLine("non static!!");
    }

    //static int multiply(int x, int y) => x*y; 

    static void outer(ref int p){
        static int inner(ref int val){
            return val+=5;
        }
        inner(ref p);
        Console.WriteLine(p);
    }

    static int Main(string[] args){
        multiply(1, 0);
        Program programInstance = new Program();
        programInstance.nonStaticFunction();
        add(10, 12);
        int n = 14;
        outer(ref n);
        return (0); 
    }
}

EOF

input=$(srcml test_method.cs --position)
output=$(echo "$input" | ./nameCollector )
expected="Program is a class in C# file: test_method.cs:3:7
add is a static int function in C# file: test_method.cs:4:16
a is a int parameter in C# file: test_method.cs:4:24
b is a int parameter in C# file: test_method.cs:4:31
nonStaticFunction is a void function in C# file: test_method.cs:8:10
outer is a static void function in C# file: test_method.cs:14:17
p is a ref int parameter in C# file: test_method.cs:14:31
inner is a static int function in C# file: test_method.cs:15:20
val is a ref int parameter in C# file: test_method.cs:15:34
Main is a static int function in C# file: test_method.cs:22:16
args is a string[] parameter in C# file: test_method.cs:22:30
programInstance is a Program local in C# file: test_method.cs:24:17
n is a int local in C# file: test_method.cs:27:13"

expected_methods=(
  "add is a static int function in C# file: test_method.cs:4:16"
  "outer is a static void function in C# file: test_method.cs:14:17"
  "inner is a static int function in C# file: test_method.cs:15:20"
  "Main is a static int function in C# file: test_method.cs:22:16"
  "nonStaticFunction is a void function in C# file: test_method.cs:8:10"
)

for method in "${expected_methods[@]}"; do
  if ! echo "$output" | grep -Fq "$method"; then
    echo "Test test_cs_method failed!"
    echo "Expected method: '$method' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_cs_method passed!" # all methods collected correctly

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cs_method output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
# Repeat tests

exit 0