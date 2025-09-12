#!/bin/bash

cat <<EOF > test_template_parameter.cpp 
#include <iostream>
//type template parameters
template <typename T>
T cls::foo() {}
template <class R>
R cls<R>::bar() {}
// non type with function
template <int U> void functionWithUParameter(U arg);
//template template
template<template<typename> class TT> struct Struct{}; 
//with default values
template<typename X = int> struct F {};
template<int N = 42> struct G {};
//paramter pack
template <typename... Ts> void ignore(Ts... ts) {}; 
// multiple parameters
template<typename P1, int P2, template<class C> class P3> struct K{};  
//nested template
template<typename Z>
struct Q {
    template<typename O>
    struct Inner {};
};
// with alias
template<typename A>
using Ptr = T*;
EOF

input=$(srcml test_template_parameter.cpp  --position)
output=$(echo "$input" | ./nameCollector )
expected="T is a template-parameter in C++ file: test_template_parameter.cpp:3:20
foo is a T function in C++ file: test_template_parameter.cpp:4:8
R is a template-parameter in C++ file: test_template_parameter.cpp:5:17
bar is a R function in C++ file: test_template_parameter.cpp:6:11
U is a template-parameter in C++ file: test_template_parameter.cpp:8:15
functionWithUParameter is a void function in C++ file: test_template_parameter.cpp:8:23
arg is a U parameter in C++ file: test_template_parameter.cpp:8:48
TT is a template-parameter in C++ file: test_template_parameter.cpp:10:35
Struct is a struct in C++ file: test_template_parameter.cpp:10:46
X is a template-parameter in C++ file: test_template_parameter.cpp:12:19
F is a struct in C++ file: test_template_parameter.cpp:12:35
N is a template-parameter in C++ file: test_template_parameter.cpp:13:14
G is a struct in C++ file: test_template_parameter.cpp:13:29
Ts is a template-parameter in C++ file: test_template_parameter.cpp:15:23
ignore is a void function in C++ file: test_template_parameter.cpp:15:32
ts is a Ts... parameter in C++ file: test_template_parameter.cpp:15:45
P1 is a template-parameter in C++ file: test_template_parameter.cpp:17:19
P2 is a template-parameter in C++ file: test_template_parameter.cpp:17:27
C is a template-parameter in C++ file: test_template_parameter.cpp:17:46
P3 is a template-parameter in C++ file: test_template_parameter.cpp:17:55
K is a struct in C++ file: test_template_parameter.cpp:17:66
Z is a template-parameter in C++ file: test_template_parameter.cpp:19:19
Q is a struct in C++ file: test_template_parameter.cpp:20:8
O is a template-parameter in C++ file: test_template_parameter.cpp:21:23
Inner is a struct in C++ file: test_template_parameter.cpp:22:12
A is a template-parameter in C++ file: test_template_parameter.cpp:25:19"

expected_template_parameters=(
  "T is a template-parameter in C++ file: test_template_parameter.cpp:3:20"
  "R is a template-parameter in C++ file: test_template_parameter.cpp:5:17"
  "U is a template-parameter in C++ file: test_template_parameter.cpp:8:15"
  "TT is a template-parameter in C++ file: test_template_parameter.cpp:10:35"
  "X is a template-parameter in C++ file: test_template_parameter.cpp:12:19"
  "N is a template-parameter in C++ file: test_template_parameter.cpp:13:14"
  "Ts is a template-parameter in C++ file: test_template_parameter.cpp:15:23"
  "P1 is a template-parameter in C++ file: test_template_parameter.cpp:17:19"
  "P2 is a template-parameter in C++ file: test_template_parameter.cpp:17:27"
  "C is a template-parameter in C++ file: test_template_parameter.cpp:17:46"
  "P3 is a template-parameter in C++ file: test_template_parameter.cpp:17:55"
  "Z is a template-parameter in C++ file: test_template_parameter.cpp:19:19"
  "O is a template-parameter in C++ file: test_template_parameter.cpp:21:23"
  "A is a template-parameter in C++ file: test_template_parameter.cpp:25:19"
)

for template_parameter in "${expected_template_parameters[@]}"; do
  if ! echo "$output" | grep -Fq "$template_parameter"; then
    echo "Test test_cpp_template_parameter failed!"
    echo "Expected function: '$template_parameter' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_cpp_template_parameter passed!"


if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_template_parameter output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

# Repeat tests

exit 0