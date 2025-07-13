#!/bin/bash

# tests the collection of class name, constructor, destructor, operator with and without space, class field, and multi file collection, and c++ macro

cat <<EOF > test_macro.hpp
#ifndef TEST_CLASS_HPP
#define TEST_CLASS_HPP
// empty macro
#endif

#define MACRO 1800
#define FOO(x,y) x*y

EOF

input=$(srcml test_macro.hpp --position)
output=$(echo "$input" | ./nameCollector )
expected="TEST_CLASS_HPP is a macro in C++ file: test_macro.hpp at 2:9
MACRO is a macro in C++ file: test_macro.hpp at 6:9
FOO is a macro in C++ file: test_macro.hpp at 7:9"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_class failed!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
echo "Test test_cpp_macro passed!"
# Repeat tests

exit 0