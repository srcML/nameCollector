#!/bin/bash

cat <<EOF > test_property.cs
class Program
{
    private int _x;
    public int X
    {
        get { return _x; }
        set { _x = value; }
    }
    public int Y { get; set; }
    public int Z { get; }
    public int A { set { /*...*/ } }
    public virtual int B { get; protected set; }
}
EOF

input=$(srcml test_property.cs  --position)
output=$(echo "$input" | ./nameCollector )
expected="Program is a class in C# file: test_property.cs:1:7
_x is a private int field in C# file: test_property.cs:3:17
X is a public int property in C# file: test_property.cs:4:16
get is a function in C# file: test_property.cs:6:9
set is a function in C# file: test_property.cs:7:9
Y is a public int property in C# file: test_property.cs:9:16
get is a function in C# file: test_property.cs:9:20
set is a function in C# file: test_property.cs:9:25
Z is a public int property in C# file: test_property.cs:10:16
get is a function in C# file: test_property.cs:10:20
A is a public int property in C# file: test_property.cs:11:16
set is a function in C# file: test_property.cs:11:20
B is a public virtual int property in C# file: test_property.cs:12:24
get is a function in C# file: test_property.cs:12:28
set is a protected function in C# file: test_property.cs:12:43"



if [[ "$output" != "$expected" ]]; then
    echo "Test test_cs_property output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_cs_property passed!"
# Repeat tests

exit 0