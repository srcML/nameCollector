#!/bin/bash

# test the collection of delegate names in C#

cat <<EOF > test_delegate.cs
delegate int PerformCalculation();
public delegate void LogMessage(string message);
class Foo
{
    Del d = delegate(int k) {} // TODO - is not currently collected correctly due to srcML markup issue
}
EOF

input=$(srcml test_delegate.cs --position)
output=$(echo "$input" | ./nameCollector )
expected="PerformCalculation is a int function typedef in C# file: test_delegate.cs:1:14
LogMessage is a void function typedef in C# file: test_delegate.cs:2:22
message is a string parameter in C# file: test_delegate.cs:2:40
Foo is a class in C# file: test_delegate.cs:3:7
d is a Del field in C# file: test_delegate.cs:5:9
k is a int parameter in C# file: test_delegate.cs:5:26"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cs_delegate failed!" 
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_cs_delegate passed!"
# Repeat tests

exit 0
