#!/bin/bash

# test the collection of struct names and struct object names
# output of struct within typedef definition includes some spacing issue and newline issue

cat <<EOF > test_struct.cs
public struct Coords {}
public readonly struct RCoords {}
unsafe struct S {}
EOF

input=$(srcml test_struct.cs --position)
output=$(echo "$input" | ./nameCollector )
expected="Coords is a struct in C# file: test_struct.cs:1:15
RCoords is a struct in C# file: test_struct.cs:2:24
S is a struct in C# file: test_struct.cs:3:15"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cs_struct output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_cs_struct passed!"
# Repeat tests

exit 0