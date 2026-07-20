#!/bin/bash

# test the collection of parameter names in c++

cat <<EOF > test_parameter.cpp
#include <iostream>
#include <vector>
// function prototypes with parameters
char convertAsciiToChar(int acsciiValue);
// multiple built in data types
int divide(int dividend, int divisor, char lable); 
// vector data type
void duplicate(std::vector<int> src, std::vector<int> copy);
// templated type
template<typename T>
T print(T &templateTypeByReference);
//with specifiers
void printPosition(const int x, const int y, const int z){
    std::cout << "your coordinates are: X["<< x <<"], Y[" << y << "], Z[" << z  << "].\n";  
}
//with modifiers
void bigNumber(long int num, unsigned y);
//with default values
char pickRandomLetter(char first, char second='b', char third='c');
//forward with no param names
int getValue(std::vector<int>, int);
//lambda function parameters
auto add = [](int x, int y) {
    return x+y;
};
//member function parameters
class C{ 
    char firstInitial;
    void printInitial(char initial) {/*empty*/};
};
//array type
void printFirst(char* arr[10]) {/*empty*/};

int main(){
    //try catch with parameter
    try {
        if (true) {
            throw std::runtime_error("An error occurred");
        }
    } catch (const std::exception& ex) {
        std::cerr << "Caught exception: " << ex.what() << std::endl;
    }
    return 0;
}
EOF

input=$(srcml test_parameter.cpp --position)
output=$(echo "$input" | ./nameCollector )
expected="convertAsciiToChar is a char function in C++ file: test_parameter.cpp:4:6
acsciiValue is a int parameter in C++ file: test_parameter.cpp:4:29
divide is a int function in C++ file: test_parameter.cpp:6:5
dividend is a int parameter in C++ file: test_parameter.cpp:6:16
divisor is a int parameter in C++ file: test_parameter.cpp:6:30
lable is a char parameter in C++ file: test_parameter.cpp:6:44
duplicate is a void function in C++ file: test_parameter.cpp:8:6
src is a std::vector<int> parameter in C++ file: test_parameter.cpp:8:33
copy is a std::vector<int> parameter in C++ file: test_parameter.cpp:8:55
T is a template-parameter in C++ file: test_parameter.cpp:10:19
print is a T function in C++ file: test_parameter.cpp:11:3
templateTypeByReference is a T & parameter in C++ file: test_parameter.cpp:11:12
printPosition is a void function in C++ file: test_parameter.cpp:13:6
x is a const int parameter in C++ file: test_parameter.cpp:13:30
y is a const int parameter in C++ file: test_parameter.cpp:13:43
z is a const int parameter in C++ file: test_parameter.cpp:13:56
bigNumber is a void function in C++ file: test_parameter.cpp:17:6
num is a long int parameter in C++ file: test_parameter.cpp:17:25
y is a unsigned parameter in C++ file: test_parameter.cpp:17:39
pickRandomLetter is a char function in C++ file: test_parameter.cpp:19:6
first is a char parameter in C++ file: test_parameter.cpp:19:28
second is a char parameter in C++ file: test_parameter.cpp:19:40
third is a char parameter in C++ file: test_parameter.cpp:19:57
getValue is a int function in C++ file: test_parameter.cpp:21:5
add is a auto global in C++ file: test_parameter.cpp:23:6
x is a int parameter in C++ file: test_parameter.cpp:23:19
y is a int parameter in C++ file: test_parameter.cpp:23:26
C is a class in C++ file: test_parameter.cpp:27:7
firstInitial is a char field in C++ file: test_parameter.cpp:28:10
printInitial is a void function in C++ file: test_parameter.cpp:29:10
initial is a char parameter in C++ file: test_parameter.cpp:29:28
printFirst is a void function in C++ file: test_parameter.cpp:32:6
arr is a char* parameter in C++ file: test_parameter.cpp:32:23
main is a int function in C++ file: test_parameter.cpp:34:5
ex is a const std::exception& parameter in C++ file: test_parameter.cpp:40:36"

expected_parameters=(
  "acsciiValue is a int parameter in C++ file: test_parameter.cpp:4:29"
  "dividend is a int parameter in C++ file: test_parameter.cpp:6:16"
  "divisor is a int parameter in C++ file: test_parameter.cpp:6:30"
  "lable is a char parameter in C++ file: test_parameter.cpp:6:44"
  "src is a std::vector<int> parameter in C++ file: test_parameter.cpp:8:33"
  "copy is a std::vector<int> parameter in C++ file: test_parameter.cpp:8:55"
  "templateTypeByReference is a T & parameter in C++ file: test_parameter.cpp:11:12"
  "x is a const int parameter in C++ file: test_parameter.cpp:13:30"
  "y is a const int parameter in C++ file: test_parameter.cpp:13:43"
  "z is a const int parameter in C++ file: test_parameter.cpp:13:56"
  "num is a long int parameter in C++ file: test_parameter.cpp:17:25"
  "y is a unsigned parameter in C++ file: test_parameter.cpp:17:39"
  "first is a char parameter in C++ file: test_parameter.cpp:19:28"
  "second is a char parameter in C++ file: test_parameter.cpp:19:40"
  "third is a char parameter in C++ file: test_parameter.cpp:19:57"
  "x is a int parameter in C++ file: test_parameter.cpp:23:19"
  "y is a int parameter in C++ file: test_parameter.cpp:23:26"
  "initial is a char parameter in C++ file: test_parameter.cpp:29:28"
  "arr is a char* parameter in C++ file: test_parameter.cpp:32:23"
  "ex is a const std::exception& parameter in C++ file: test_parameter.cpp:40:36"
)

# make sure parameters are collected correctly in both hpp and cpp files
for parameter in "${expected_parameters[@]}"; do
  if ! echo "$output" | grep -Fq "$parameter"; then
    echo "Test test_cpp_parameter failed!"
    echo "Expected parameter: '$parameter' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_cpp_parameter passed!" # all parameters collected correctly

# fail if output does not match expected, even if the parameters are collected correctly
if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_parameter output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi

# Repeat tests

exit 0