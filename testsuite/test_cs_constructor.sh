#!/bin/bash

# test the collection of constructor names in C#

cat <<EOF > test_constructor.cs
class A
{
    public A() {}
    public A(int x) : this() {}
    static A() {}
}
struct S
{
    public int X;
    public S(int x) {}
    public S() {}
}
// TODO - add records when srcML supports them
EOF

input=$(srcml test_constructor.cs --position)
output=$(echo "$input" | ./nameCollector)
expected="A is a class in C# file: test_constructor.cs:1:7
A is a constructor in C# file: test_constructor.cs:3:12
A is a constructor in C# file: test_constructor.cs:4:12
x is a int parameter in C# file: test_constructor.cs:4:18
A is a constructor in C# file: test_constructor.cs:5:12
S is a struct in C# file: test_constructor.cs:7:8
X is a public int field in C# file: test_constructor.cs:9:16
S is a constructor in C# file: test_constructor.cs:10:12
x is a int parameter in C# file: test_constructor.cs:10:18
S is a constructor in C# file: test_constructor.cs:11:12"


# fail if output does not match expected, even if the constructors are collected correctly
if [[ "$output" != "$expected" ]]; then
    echo "Test test_cs_constructor output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_cs_constructor passed!"
# Repeat tests

exit 0
