#!/bin/bash

# tests the collection of public, private, and protected fields in a cpp class, fails if any field is collected incorrectly
# also fails is output does not otherwise match expected, even if all fields are correct

cat <<EOF > test_class_fields.hpp
#ifndef TEST_CLASS_HPP
#define TEST_CLASS_HPP

class Counter{
public:
    Counter();
    Counter(int value);
    ~Counter();
    Counter& operator --();

    char public_field;
    static int static_field; 
private:
    int *counter_value;

protected:
    float protected_field;
};

#endif

EOF

cat <<EOF > test_class_fields.cpp
#include "test_class_fields.hpp"
#include <iostream>

Counter::Counter() : counter_value(new int(0)) {}

Counter::Counter(int value) : counter_value(new int(value)) {}

Counter::~Counter() {
    if (counter_value) {
        delete counter_value;
        counter_value = nullptr;
    }
}

Counter& Counter::operator --() {
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

input=$(srcml test_class_fields.hpp test_class_fields.cpp --position)
output=$(echo "$input" | ./nameCollector )
expected="TEST_CLASS_HPP is a macro in C++ file: test_class_fields.hpp:2:9
Counter is a class in C++ file: test_class_fields.hpp:4:7
Counter is a constructor in C++ file: test_class_fields.hpp:6:5
Counter is a constructor in C++ file: test_class_fields.hpp:7:5
value is a int parameter in C++ file: test_class_fields.hpp:7:17
~Counter is a destructor in C++ file: test_class_fields.hpp:8:5
operator -- is a Counter& function in C++ file: test_class_fields.hpp:9:14
public_field is a char field in C++ file: test_class_fields.hpp:11:10
static_field is a static int field in C++ file: test_class_fields.hpp:12:16
counter_value is a int * field in C++ file: test_class_fields.hpp:14:10
protected_field is a float field in C++ file: test_class_fields.hpp:17:11
Counter is a constructor in C++ file: test_class_fields.cpp:4:10
Counter is a constructor in C++ file: test_class_fields.cpp:6:10
value is a int parameter in C++ file: test_class_fields.cpp:6:22
~Counter is a destructor in C++ file: test_class_fields.cpp:8:10
operator -- is a Counter& function in C++ file: test_class_fields.cpp:15:19
main is a int function in C++ file: test_class_fields.cpp:20:5
defaultCounter is a Counter local in C++ file: test_class_fields.cpp:21:13
seven is a Counter local in C++ file: test_class_fields.cpp:22:13"

expected_fields=(
  "public_field is a char field in C++ file: test_class_fields.hpp:11:10"
  "static_field is a static int field in C++ file: test_class_fields.hpp:12:16"
  "counter_value is a int * field in C++ file: test_class_fields.hpp:14:10"
  "protected_field is a float field in C++ file: test_class_fields.hpp:17:11"
)

# make sure fields are collected correctly in both hpp and cpp files
for field in "${expected_fields[@]}"; do
  if ! echo "$output" | grep -Fq "$field"; then
    echo "Test test_cpp_class_field failed!"
    echo "Expected field: '$field' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_cpp_class_field passed!" # all fields collected correctly

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_class_fields output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

# Repeat tests

exit 0