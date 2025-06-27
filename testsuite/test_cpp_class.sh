#!/bin/bash

# tests the collection of class name, constructor, destructor, operator with and without space, class field, and multi file collection, and c++ macro

cat <<EOF > test_class.hpp
#ifndef TEST_CLASS_HPP
#define TEST_CLASS_HPP

class Counter{
public:
    Counter();
    Counter(int value);
    ~Counter();
    Counter& operator++();
    Counter& operator --();
    void display();

private:
   int *counter_value;
};

#endif

EOF

cat <<EOF > test_class.cpp
#include "tes_class.hpp"
#include <iostream>

Counter::Counter() : counter_value(new int(0)) {}

Counter::Counter(int value) : counter_value(new int(value)) {}

Counter::~Counter() {
    if (counter_value) {
        delete counter_value;
        counter_value = nullptr;
    }
}

Counter& Counter::operator++() {
    ++(*counter_value);
    return *this;
}

Counter& Counter::operator --() {
    --(*counter_value);
    return *this;
}

void Counter::display() {
    std::cout << *counter_value << std::endl;
}

int main(){
    Counter defaultCounter;
    Counter seven(7);
    --seven;
    ++defaultCounter;
    seven.display();
    defaultCounter.display();
    return 0;
}
EOF

input=$(srcml test_class.hpp test_class.cpp --position)
output=$(echo "$input" | ./nameCollector )
expected="TEST_CLASS_HPP is a macro in C++ file: test_class.hpp at 2:9
Counter is a class in C++ file: test_class.hpp at 4:7
Counter is a constructor in C++ file: test_class.hpp at 6:5
Counter is a constructor in C++ file: test_class.hpp at 7:5
value is a int parameter in C++ file: test_class.hpp at 7:17
~Counter is a destructor in C++ file: test_class.hpp at 8:5
operator++ is a Counter& function in C++ file: test_class.hpp at 9:14
operator -- is a Counter& function in C++ file: test_class.hpp at 10:14
display is a void function in C++ file: test_class.hpp at 11:10
counter_value is a int * field in C++ file: test_class.hpp at 14:9
Counter is a constructor in C++ file: test_class.cpp at 4:10
Counter is a constructor in C++ file: test_class.cpp at 6:10
value is a int parameter in C++ file: test_class.cpp at 6:22
~Counter is a destructor in C++ file: test_class.cpp at 8:10
operator++ is a Counter& function in C++ file: test_class.cpp at 15:19
operator -- is a Counter& function in C++ file: test_class.cpp at 20:19
display is a void function in C++ file: test_class.cpp at 25:15
main is a int function in C++ file: test_class.cpp at 29:5
defaultCounter is a Counter local in C++ file: test_class.cpp at 30:13
seven is a Counter local in C++ file: test_class.cpp at 31:13"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_class failed!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

# Repeat tests

exit 0