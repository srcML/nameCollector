#!/bin/bash

# test the collection of names defined in a using statement in C#

cat <<EOF > test_using.cs
using ProjectId = System.Int32;
global using Point2D = System.ValueTuple<double, double>;
using System;
EOF

input=$(srcml test_using.cs --position)
output=$(echo "$input" | ./nameCollector )
expected="ProjectID is a System.Int32 typedef in C# file: test_using.cs:1:7
Point2d is a System.ValueTuple<double, double> typedef in C# file: test_using.cs:2:14"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cs_using failed!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
echo "Test test_cs_using passed!"
# Repeat tests

exit 0
