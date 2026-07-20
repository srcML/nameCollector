#!/bin/bash

# tests the collection of fields in C#

cat <<EOF > test_field.cs
class CLS
{
    int x;
    static int y;
    public const int z = 10;
    readonly int a;
    public static int b = 20;
    static readonly int c = 30;
    volatile int d;
    private int e;
    protected int f;
    internal int g;
    private protected int h;
    int i, j, k;
    int? l;
    public required int m;
}

struct S
{
    public int size;
    //public fixed int buffer[10]; // TODO - this is current unsupported markup
}

interface I
{
    const int A = 1;
    static int B = 2;
}

enum E
{
    X = 0,
    Y = 1
}

EOF

input=$(srcml test_field.cs --position)
output=$(echo "$input" | ./nameCollector )
expected="CLS is a class in C# file: test_field.cs:1:7
x is a int field in C# file: test_field.cs:3:9
y is a static int field in C# file: test_field.cs:4:16
z is a public const int field in C# file: test_field.cs:5:22
a is a readonly int field in C# file: test_field.cs:6:18
b is a public static int field in C# file: test_field.cs:7:23
c is a static readonly int field in C# file: test_field.cs:8:25
d is a volatile int field in C# file: test_field.cs:9:18
e is a private int field in C# file: test_field.cs:10:17
f is a protected int field in C# file: test_field.cs:11:19
g is a internal int field in C# file: test_field.cs:12:18
h is a private protected int field in C# file: test_field.cs:13:27
i is a int field in C# file: test_field.cs:14:9
j is a int field in C# file: test_field.cs:14:12
k is a int field in C# file: test_field.cs:14:15
l is a int? field in C# file: test_field.cs:15:10
m is a public required int field in C# file: test_field.cs:16:25
S is a struct in C# file: test_field.cs:19:8
size is a public int field in C# file: test_field.cs:21:16
I is an interface in C# file: test_field.cs:25:11
A is a const int field in C# file: test_field.cs:27:15
B is a static int field in C# file: test_field.cs:28:16
E is a enum in C# file: test_field.cs:31:6
X is a field in C# file: test_field.cs:33:5
Y is a field in C# file: test_field.cs:34:5"


if [[ "$output" != "$expected" ]]; then
    echo "Test test_cs_field output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_cs_field passed!"
# Repeat tests

exit 0