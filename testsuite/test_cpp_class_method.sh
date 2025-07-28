#!/bin/bash

# tests the collection of class methods 

cat <<EOF > test_class_method.hpp
#ifndef TEST_CLASS_HPP
#define TEST_CLASS_HPP

class Counter{
public:
    Counter();
    Counter(int value);
    ~Counter();
    Counter& operator --();
    
    char public_field;
    void display();
private:
    int *counter_value;

protected:
    float protected_field;
};

#endif

EOF

cat <<EOF > test_class_method.cpp
#include "test_class_method.hpp"
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

void Counter::display(){
    std::cout << *counter_value << std::endl; 
}

int main(){
    Counter defaultCounter;
    Counter seven(7);
    seven.display();
    --seven;
    return 0;
}
EOF

input=$(srcml test_class_method.hpp test_class_method.cpp --position)
output=$(echo "$input" | ./nameCollector )
expected="TEST_CLASS_HPP is a macro in C++ file: test_class_method.hpp at 2:9
Counter is a class in C++ file: test_class_method.hpp at 4:7
Counter is a constructor in C++ file: test_class_method.hpp at 6:5
Counter is a constructor in C++ file: test_class_method.hpp at 7:5
value is a int parameter in C++ file: test_class_method.hpp at 7:17
~Counter is a destructor in C++ file: test_class_method.hpp at 8:5
operator -- is a Counter& function in C++ file: test_class_method.hpp at 9:14
public_field is a char field in C++ file: test_class_method.hpp at 11:10
display is a void function in C++ file: test_class_method.hpp at 12:10
counter_value is a int * field in C++ file: test_class_method.hpp at 14:10
protected_field is a float field in C++ file: test_class_method.hpp at 17:11
Counter is a constructor in C++ file: test_class_method.cpp at 4:10
Counter is a constructor in C++ file: test_class_method.cpp at 6:10
value is a int parameter in C++ file: test_class_method.cpp at 6:22
~Counter is a destructor in C++ file: test_class_method.cpp at 8:10
operator -- is a Counter& function in C++ file: test_class_method.cpp at 15:19
display is a void function in C++ file: test_class_method.cpp at 20:15
main is a int function in C++ file: test_class_method.cpp at 24:5
defaultCounter is a Counter local in C++ file: test_class_method.cpp at 25:13
seven is a Counter local in C++ file: test_class_method.cpp at 26:13"

expected_methods=(
  "display is a void function in C++ file: test_class_method.hpp at 12:10"
  "display is a void function in C++ file: test_class_method.cpp at 20:15"
)

# make sure fields are collected correctly in both hpp and cpp files
for method in "${expected_methods[@]}"; do
  if ! echo "$output" | grep -Fq "$method"; then
    echo "Test test_cpp_class_method failed!"
    echo "Expected method: '$method' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_cpp_class_method passed!" # all fields collected correctly

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_class_method output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

# Repeat tests

exit 0