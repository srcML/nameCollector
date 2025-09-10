#!/bin/bash

# test the collection of global variable names in c++

cat <<EOF > test_function_parameter.cpp 
#include <iostream>

//should collect function_parameter_one as a function pointer parameter
void callback_one(int x) {}
void test_one_parameter(void (*function_parameter_one)(int)) { function_parameter_one(1); }

//test with multiple parameters for the function-parameter
int callback_two(int, double) { return 0; }
void test_multiple_parameters(int (*function_parameter_two)(int, double)) { function_parameter_two(1, 2.0); 

//test function param by reference
void test_by_reference(void (&function_parameter_three)(int)) { function_parameter_three(2); }

//test multiple fuction parameters
void test_multiple_function_parameters(void (*function_parameterA)(int), int (*function_parameterB)(int)) { function_parameterA(2); }

EOF

input=$(srcml test_function_parameter.cpp  --position)
output=$(echo "$input" | ./nameCollector )
expected="callback_one is a void function in C++ file: test_function_parameter.cpp:4:6
x is a int parameter in C++ file: test_function_parameter.cpp:4:23
test_one_parameter is a void function in C++ file: test_function_parameter.cpp:5:6
function_parameter_one is a function-parameter in C++ file: test_function_parameter.cpp:5:32
callback_two is a int function in C++ file: test_function_parameter.cpp:8:5
test_multiple_parameters is a void function in C++ file: test_function_parameter.cpp:9:6
function_parameter_two is a function-parameter in C++ file: test_function_parameter.cpp:9:37
test_by_reference is a void function in C++ file: test_function_parameter.cpp:12:6
function_parameter_three is a function-parameter in C++ file: test_function_parameter.cpp:12:31
test_multiple_function_parameters is a void function in C++ file: test_function_parameter.cpp:15:6
function_parameterA is a function-parameter in C++ file: test_function_parameter.cpp:15:47
function_parameterB is a function-parameter in C++ file: test_function_parameter.cpp:15:80"

expected_function_parameters=(
  "function_parameter_one is a function-parameter in C++ file: test_function_parameter.cpp:5:32"
  "function_parameter_two is a function-parameter in C++ file: test_function_parameter.cpp:9:37"
  "function_parameter_three is a function-parameter in C++ file: test_function_parameter.cpp:12:31"
  "function_parameterA is a function-parameter in C++ file: test_function_parameter.cpp:15:47"
  "function_parameterB is a function-parameter in C++ file: test_function_parameter.cpp:15:80"
)

# make sure contructors are collected correctly in both hpp and cpp files
for function_parameter in "${expected_function_parameters[@]}"; do
  if ! echo "$output" | grep -Fq "$function_parameter"; then
    echo "Test test_cpp_function_parameter failed!"
    echo "Expected function: '$function_parameter' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_cpp_function_parameter passed!"


if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_function_parameter output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

# Repeat tests

exit 0