#!/bin/bash

# tests the collection of class name, constructor, destructor, operator with and without space, class field, and multi file collection, and c++ macro

cat <<EOF > test_macro.hpp
#ifndef TEST_CLASS_HPP
#define TEST_CLASS_HPP
// empty macro
#endif

#define MACRO 1800

EOF

input=$(srcml test_macro.hpp --position)
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