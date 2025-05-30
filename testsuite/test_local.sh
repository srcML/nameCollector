#!/bin/bash

input=$(srcml test_local.cpp)
output=$(echo "$input" | ../bin/nameCollector )
expected="multiply is a int function in C++ file: test_local.cpp
a is a int parameter in C++ file: test_local.cpp
b is a int parameter in C++ file: test_local.cpp
return_value is a int local in C++ file: test_local.cpp"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_local failed!"
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi

# Repeat tests

exit 0