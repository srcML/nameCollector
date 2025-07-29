#!/bin/bash

# tests the collection of class destructor, if any of the expected output lines for each destructor 
# in each file are missing, test will fail, test will also fail if output does not match expected, even if
# destructors are collected properly

cat <<EOF > test_class_destructor.hpp
#ifndef TEST_CLASS_HPP
#define TEST_CLASS_HPP

class Counter{
public:
    Counter();
    Counter(int value);
    ~Counter();
private:
   int *counter_value;
};

#endif

EOF

cat <<EOF > test_class_destructor.cpp
#include "test_class_destructor.hpp"
#include <iostream>

Counter::Counter() : counter_value(new int(0)) {}

Counter::Counter(int value) : counter_value(new int(value)) {}

Counter::~Counter() {
    if (counter_value) {
        delete counter_value;
        counter_value = nullptr;
    }
}

int main(){
    Counter defaultCounter;
    Counter seven(7);
    return 0;
}
EOF

input=$(srcml test_class_destructor.hpp test_class_destructor.cpp --position)
output=$(echo "$input" | ./nameCollector )
expected="TEST_CLASS_HPP is a macro in C++ file: test_class_destructor.hpp:2:9
Counter is a class in C++ file: test_class_destructor.hpp:4:7
Counter is a constructor in C++ file: test_class_destructor.hpp:6:5
Counter is a constructor in C++ file: test_class_destructor.hpp:7:5
value is a int parameter in C++ file: test_class_destructor.hpp:7:17
~Counter is a destructor in C++ file: test_class_destructor.hpp:8:5
counter_value is a int * field in C++ file: test_class_destructor.hpp:10:9
Counter is a constructor in C++ file: test_class_destructor.cpp:4:10
Counter is a constructor in C++ file: test_class_destructor.cpp:6:10
value is a int parameter in C++ file: test_class_destructor.cpp:6:22
~Counter is a destructor in C++ file: test_class_destructor.cpp:8:10
main is a int function in C++ file: test_class_destructor.cpp:15:5
defaultCounter is a Counter local in C++ file: test_class_destructor.cpp:16:13
seven is a Counter local in C++ file: test_class_destructor.cpp:17:13"

expected_destructors=(
  "~Counter is a destructor in C++ file: test_class_destructor.hpp:8:5"
  "~Counter is a destructor in C++ file: test_class_destructor.cpp:8:10"
)

# make sure destructors are collected correctly in both hpp and cpp files
for destructor in "${expected_destructors[@]}"; do
  if ! echo "$output" | grep -Fq "$destructor"; then
    echo "Test test_cpp_class_destructor failed!"
    echo "Expected destructor: '$destructor' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_cpp_class_destructor passed!" # all destructors collected correctly

# fail if output does not match expected, even if the destructors are collected correctly
if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_class_desstructor output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

# Repeat tests

exit 0