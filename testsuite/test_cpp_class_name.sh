#!/bin/bash

# tests the collection of class name, only fails is class name is improperly collected or if main is improperly collected

cat <<EOF > test_class_name.cpp
#include <iostream>

class Counter; //testing class forward collection

class Counter{
// empty class to test class name collection
};

int main(){
    return 0;
}
EOF

input=$(srcml test_class_name.cpp --position)
output=$(echo "$input" | ./nameCollector )
expected="Counter is a class in C++ file: test_class_name.cpp at 3:7
Counter is a class in C++ file: test_class_name.cpp at 5:7
main is a int function in C++ file: test_class_name.cpp at 9:5"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_class_name failed!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
echo "Test test_cpp_class_name passed!"
# Repeat tests

exit 0