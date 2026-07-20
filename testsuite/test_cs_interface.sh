#!/bin/bash

# test the collection of interface names in C#

cat <<EOF > test_interface.cs
interface IMyInterface {}
public interface IVehicle {}
interface IFuncExample {
    void DoWork();
}
interface IEventExample
{
    event EventHandler SomethingHappened;
}
interface IPropExample
{
    static int Value {}
}

EOF

input=$(srcml test_interface.cs --position)
output=$(echo "$input" | ./nameCollector )
expected="IMyInterface is a interface in C# file: test_interface.cs:1:11
IVehicle is a interface in C# file: test_interface.cs:2:18
IFuncExample is a interface in C# file: test_interface.cs:3:11
DoWork is a void function in C# file: test_interface.cs:4:10
IEventExample is a interface in C# file: test_interface.cs:6:11
SomethingHappened is a EventHandler event in C# file: test_interface.cs:8:24
IPropExample is a interface in C# file: test_interface.cs:10:11
Value is a static int property in C# file: test_interface.cs:12:16"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cs_interface failed!" 
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_cs_interface passed!"
# Repeat tests

exit 0
