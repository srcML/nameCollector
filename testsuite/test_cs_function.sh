#!/bin/bash

# test the collection of function names in C#

cat <<EOF > test_function.cs
public class Foo {
    string AppendPathSeparator() {}
    public static void Main() {}
    public static IEnumerable<int> OddSequence() {}
    public async Task<string> PerformLongRunningWork() {
        async Task<string> longRunningWorkImplementation() {}
    }
    public Foo() {}
    static Foo() {}
    ~Foo() {}
}
EOF

input=$(srcml test_function.cs --position)
output=$(echo "$input" | ./nameCollector)
expected="Foo is a class in C# file: test_function.cs:1:14
AppendPathSeparator is a string function in C# file: test_function.cs:2:12
Main is a public static void function in C# file: test_function.cs:3:24
OddSequence is a public static IEnumerable<int> function in C# file: test_function.cs:4:36
PerformLongRunningWork is a public async Task<string> function in C# file: test_function.cs:5:31
longRunningWorkImplementation is a async Task<string> function in C# file: test_function.cs:6:28
Foo is a constructor in C# file: test_function.cs:8:12
Foo is a constructor in C# file: test_function.cs:9:12
~Foo is a destructor in C# file: test_function.cs:10:5"


# fail if output does not match expected, even if the constructors are collected correctly
if [[ "$output" != "$expected" ]]; then
    echo "Test test_cs_function output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_cs_function passed!"
# Repeat tests

exit 0
