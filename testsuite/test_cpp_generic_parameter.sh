#!/bin/bash

cat <<EOF > test_generic_parameter.cpp 
#include <iostream>
//type template parameters
template <typename T>
T function(T arg) {
    return arg;
}
template <class R>
R classParameter () {}
// non type with function
template <int U> 
int data[U] = {0};
//template template
template<template<typename> class TT> 
struct wrapper{ TT<int> intWrapper;}; 
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
using A_ptr = A*;

int main() {
    return 0;
}
EOF

input=$(srcml test_generic_parameter.cpp  --position)
output=$(echo "$input" | ./nameCollector )
expected="T is a typename generic-parameter in C++ file: test_generic_parameter.cpp:3:20
function is a T function in C++ file: test_generic_parameter.cpp:4:3
arg is a T parameter in C++ file: test_generic_parameter.cpp:4:14
R is a class generic-parameter in C++ file: test_generic_parameter.cpp:7:17
classParameter is a R function in C++ file: test_generic_parameter.cpp:8:3
U is a int generic-parameter in C++ file: test_generic_parameter.cpp:10:15
data is a int global in C++ file: test_generic_parameter.cpp:11:5
TT is a template<typename> class generic-parameter in C++ file: test_generic_parameter.cpp:13:35
wrapper is a struct in C++ file: test_generic_parameter.cpp:14:8
intWrapper is a TT<int> field in C++ file: test_generic_parameter.cpp:14:25
X is a typename generic-parameter in C++ file: test_generic_parameter.cpp:16:19
F is a struct in C++ file: test_generic_parameter.cpp:16:35
N is a int generic-parameter in C++ file: test_generic_parameter.cpp:17:14
G is a struct in C++ file: test_generic_parameter.cpp:17:29
Ts is a typename... generic-parameter in C++ file: test_generic_parameter.cpp:19:23
ignore is a void function in C++ file: test_generic_parameter.cpp:19:32
ts is a Ts... parameter in C++ file: test_generic_parameter.cpp:19:45
P1 is a typename generic-parameter in C++ file: test_generic_parameter.cpp:21:19
P2 is a int generic-parameter in C++ file: test_generic_parameter.cpp:21:27
C is a class generic-parameter in C++ file: test_generic_parameter.cpp:21:46
P3 is a template<class C> class generic-parameter in C++ file: test_generic_parameter.cpp:21:55
K is a struct in C++ file: test_generic_parameter.cpp:21:66
Z is a typename generic-parameter in C++ file: test_generic_parameter.cpp:23:19
Q is a struct in C++ file: test_generic_parameter.cpp:24:8
O is a typename generic-parameter in C++ file: test_generic_parameter.cpp:25:23
Inner is a struct in C++ file: test_generic_parameter.cpp:26:12
A is a typename generic-parameter in C++ file: test_generic_parameter.cpp:29:19
A_ptr is a A* typedef in C++ file: test_generic_parameter.cpp:30:7
main is a int function in C++ file: test_generic_parameter.cpp:32:5"

expected_generic_parameters=(
  "T is a typename generic-parameter in C++ file: test_generic_parameter.cpp:3:20"
  "R is a class generic-parameter in C++ file: test_generic_parameter.cpp:7:17"
  "U is a int generic-parameter in C++ file: test_generic_parameter.cpp:10:15"
  "TT is a template<typename> class generic-parameter in C++ file: test_generic_parameter.cpp:13:35"
  "X is a typename generic-parameter in C++ file: test_generic_parameter.cpp:16:19"
  "N is a int generic-parameter in C++ file: test_generic_parameter.cpp:17:14"
  "Ts is a typename... generic-parameter in C++ file: test_generic_parameter.cpp:19:23"
  "P1 is a typename generic-parameter in C++ file: test_generic_parameter.cpp:21:19"
  "P2 is a int generic-parameter in C++ file: test_generic_parameter.cpp:21:27"
  "C is a class generic-parameter in C++ file: test_generic_parameter.cpp:21:46"
  "P3 is a template<class C> class generic-parameter in C++ file: test_generic_parameter.cpp:21:55"
  "Z is a typename generic-parameter in C++ file: test_generic_parameter.cpp:23:19"
  "O is a typename generic-parameter in C++ file: test_generic_parameter.cpp:25:23"
  "A is a typename generic-parameter in C++ file: test_generic_parameter.cpp:29:19"
)

for generic_parameter in "${expected_generic_parameters[@]}"; do
  if ! echo "$output" | grep -Fq "$generic_parameter"; then
    echo "Test test_cpp_generic_parameter failed!"
    echo "Expected function: '$generic_parameter' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_cpp_generic_parameter passed!"


if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_generic_parameter output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi

# Repeat tests

exit 0