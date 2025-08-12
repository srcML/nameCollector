#!/bin/bash

# tests the collection of operators with no spaces, fails if the output for collecting operators with no spaces
# does not match expected for them, also fails if output does not otherwise match expected

cat <<EOF > test_operator_no_space.hpp
#ifndef TEST_CLASS_HPP
#define TEST_CLASS_HPP

class Counter{
public:
    Counter();
    Counter(int value);
    ~Counter();
    Counter& operator--();

private:
   int *counter_value;
};

#endif

EOF

cat <<EOF > test_operator_no_space.cpp
#include "test_class.hpp"
#include <iostream>

Counter::Counter() : counter_value(new int(0)) {}

Counter::Counter(int value) : counter_value(new int(value)) {}

Counter::~Counter() {
    if (counter_value) {
        delete counter_value;
        counter_value = nullptr;
    }
}

Counter& Counter::operator--() {
    --(*counter_value);
    return *this;
}

int main(){
    Counter defaultCounter;
    Counter seven(7);
    --seven;
    return 0;
}
EOF

input=$(srcml test_operator_no_space.hpp test_operator_no_space.cpp --position)
output=$(echo "$input" | ./nameCollector )
expected="TEST_CLASS_HPP is a macro in C++ file: test_operator_no_space.hpp:2:9
Counter is a class in C++ file: test_operator_no_space.hpp:4:7
Counter is a constructor in C++ file: test_operator_no_space.hpp:6:5
Counter is a constructor in C++ file: test_operator_no_space.hpp:7:5
value is a int parameter in C++ file: test_operator_no_space.hpp:7:17
~Counter is a destructor in C++ file: test_operator_no_space.hpp:8:5
operator-- is a Counter& function in C++ file: test_operator_no_space.hpp:9:14
counter_value is a int * field in C++ file: test_operator_no_space.hpp:12:9
Counter is a constructor in C++ file: test_operator_no_space.cpp:4:10
Counter is a constructor in C++ file: test_operator_no_space.cpp:6:10
value is a int parameter in C++ file: test_operator_no_space.cpp:6:22
~Counter is a destructor in C++ file: test_operator_no_space.cpp:8:10
operator-- is a Counter& function in C++ file: test_operator_no_space.cpp:15:19
main is a int function in C++ file: test_operator_no_space.cpp:20:5
defaultCounter is a Counter local in C++ file: test_operator_no_space.cpp:21:13
seven is a Counter local in C++ file: test_operator_no_space.cpp:22:13"

expected_operators=(
  "operator-- is a Counter& function in C++ file: test_operator_no_space.hpp:9:14"
  "operator-- is a Counter& function in C++ file: test_operator_no_space.cpp:15:19"
)

# make sure operators with spaces are collected correctly in both hpp and cpp files
for operator in "${expected_operators[@]}"; do
  if ! echo "$output" | grep -Fq "$operator"; then
    echo "Test test_cpp_operator_no_space failed!"
    echo "Expected operator with no space: '$operator' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_cpp_operator_no_space passed!" # all operators with no spaces collected correctly

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_operator_no_space output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

# Repeat tests

exit 0