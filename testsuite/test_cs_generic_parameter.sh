#!/bin/bash

cat <<EOF > test_generic_parameter.cs 
public class Box<T> {}
class MyClass<TKey, TValue> {}
public class Utility
{
    public static U Identity<U>() {}
}
struct Pair<A> {}
interface IRepository<B> {}
class Container<C>
{
    public D Convert<D>(C input) { }
}

EOF

input=$(srcml test_generic_parameter.cs  --position)
output=$(echo "$input" | ./nameCollector )
expected="Box is a class in C# file: test_generic_parameter.cs:1:14
T is a generic-parameter in C# file: test_generic_parameter.cs:1:18
MyClass is a class in C# file: test_generic_parameter.cs:2:7
TKey is a generic-parameter in C# file: test_generic_parameter.cs:2:15
TValue is a generic-parameter in C# file: test_generic_parameter.cs:2:21
Utility is a class in C# file: test_generic_parameter.cs:3:14
Identity is a public static U function in C# file: test_generic_parameter.cs:5:21
U is a generic-parameter in C# file: test_generic_parameter.cs:3:30
Pair is a struct in C# file: test_generic_parameter.cs:7:8
A is a generic-parameter in C# file: test_generic_parameter.cs:7:13
IRepository is a interface in C# file: test_generic_parameter.cs:8:11
B is a generic-parameter in C# file: test_generic_parameter.cs:8:23
Container is a class in C# file: test_generic_parameter.cs:9:7
C is a generic-parameter in C# file: test_generic_parameter.cs:9:17
Convert is a public D function in C# file: test_generic_parameter.cs:11:14
D is a generic-parameter in C# file: test_generic_parameter.cs:11:22"



if [[ "$output" != "$expected" ]]; then
    echo "Test test_cs_generic_parameter output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_cs_generic_parameter passed!"
# Repeat tests

exit 0