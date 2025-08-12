#!/bin/bash

# tests the collection of class constructor, if any of the expected output lines for each constructor 
# in each file are missing, test will fail, will also fail if ouput does not otherwise match expected

cat <<EOF > test_class_constructor.hpp
#ifndef TEST_CLASS_HPP
#define TEST_CLASS_HPP

class Counter{
public:
    Counter();
    Counter(int value);
private:
   int *counter_value;
};

#endif
EOF

cat <<EOF > test_class_constructor.cpp
#include "test_class_constructor.hpp"
#include <iostream>

Counter::Counter() : counter_value(new int(0)) {}

Counter::Counter(int value) : counter_value(new int(value)) {}

int main(){
    Counter defaultCounter;
    Counter seven(7);
    return 0;
}
EOF

input=$(srcml test_class_constructor.hpp test_class_constructor.cpp --position)
output=$(echo "$input" | ./nameCollector )
expected="TEST_CLASS_HPP is a macro in C++ file: test_class_constructor.hpp:2:9
Counter is a class in C++ file: test_class_constructor.hpp:4:7
Counter is a constructor in C++ file: test_class_constructor.hpp:6:5
Counter is a constructor in C++ file: test_class_constructor.hpp:7:5
value is a int parameter in C++ file: test_class_constructor.hpp:7:17
counter_value is a int * field in C++ file: test_class_constructor.hpp:9:9
Counter is a constructor in C++ file: test_class_constructor.cpp:4:10
Counter is a constructor in C++ file: test_class_constructor.cpp:6:10
value is a int parameter in C++ file: test_class_constructor.cpp:6:22
main is a int function in C++ file: test_class_constructor.cpp:8:5
defaultCounter is a Counter local in C++ file: test_class_constructor.cpp:9:13
seven is a Counter local in C++ file: test_class_constructor.cpp:10:13"

expected_constructors=(
  "Counter is a constructor in C++ file: test_class_constructor.hpp:6:5"
  "Counter is a constructor in C++ file: test_class_constructor.hpp:7:5"
  "Counter is a constructor in C++ file: test_class_constructor.cpp:4:10"
  "Counter is a constructor in C++ file: test_class_constructor.cpp:6:10"
)

# make sure contructors are collected correctly in both hpp and cpp files
for constructor in "${expected_constructors[@]}"; do
  if ! echo "$output" | grep -Fq "$constructor"; then
    echo "Test test_cpp_class_constructor failed!"
    echo "Expected constructor: '$constructor' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_cpp_class_constructor passed!" # all constructor collected correctly

# fail if output does not match expected, even if the constructors are collected correctly
if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_class_constructor output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

# Repeat tests

exit 0