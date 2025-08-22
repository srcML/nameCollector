#!/bin/bash

# test the collection of parameter names in c++

cat <<EOF > test_parameter.cpp
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
char pickRandomLetter(char first, char second=b, char third=c);
//forward with no param names
int getValue(std::vector<int>, int);
//lambda function parameters
auto add = [](int x, int y) {
    return x+y;
};
//member function parameters
class C{ 
    char firstInitial;
    void printInitial(char initial) {//empty};
}
//array type
void printFirst(char* arr[10]);
//try catch with parameter
try {
    // empty
} catch (const std::exception& ex) {
    // empty
}
EOF

input=$(srcml test_parameter.cpp --position)
output=$(echo "$input" | ./nameCollector )
expected="convertAsciiToChar is a char function in C++ file: test_parameter.cpp:2:6
acsciiValue is a int parameter in C++ file: test_parameter.cpp:2:29
divide is a int function in C++ file: test_parameter.cpp:4:5
dividend is a int parameter in C++ file: test_parameter.cpp:4:16
divisor is a int parameter in C++ file: test_parameter.cpp:4:30
lable is a char parameter in C++ file: test_parameter.cpp:4:44
duplicate is a void function in C++ file: test_parameter.cpp:6:6
src is a std::vector<int> parameter in C++ file: test_parameter.cpp:6:33
copy is a std::vector<int> parameter in C++ file: test_parameter.cpp:6:55
T is a template-parameter in C++ file: test_parameter.cpp:8:19
print is a T function in C++ file: test_parameter.cpp:9:3
templateTypeByReference is a T & parameter in C++ file: test_parameter.cpp:9:12
printPosition is a void function in C++ file: test_parameter.cpp:11:6
x is a const int parameter in C++ file: test_parameter.cpp:11:30
y is a const int parameter in C++ file: test_parameter.cpp:11:43
z is a const int parameter in C++ file: test_parameter.cpp:11:56
bigNumber is a void function in C++ file: test_parameter.cpp:15:6
num is a long int parameter in C++ file: test_parameter.cpp:15:25
y is a unsigned parameter in C++ file: test_parameter.cpp:15:39
pickRandomLetter is a char function in C++ file: test_parameter.cpp:17:6
first is a char parameter in C++ file: test_parameter.cpp:17:28
second is a char parameter in C++ file: test_parameter.cpp:17:40
third is a char parameter in C++ file: test_parameter.cpp:17:55
getValue is a int function in C++ file: test_parameter.cpp:19:5
add is a auto global in C++ file: test_parameter.cpp:21:6
x is a int parameter in C++ file: test_parameter.cpp:21:19
y is a int parameter in C++ file: test_parameter.cpp:21:26
C is a class in C++ file: test_parameter.cpp:25:7
firstInitial is a char field in C++ file: test_parameter.cpp:26:10
printInitial is a void function in C++ file: test_parameter.cpp:27:10
initial is a char parameter in C++ file: test_parameter.cpp:27:28
printFirst is a void function in C++ file: test_parameter.cpp:30:6
arr is a char* parameter in C++ file: test_parameter.cpp:30:23
ex is a const std::exception& parameter in C++ file: test_parameter.cpp:34:32"

expected_parameters=(
  "acsciiValue is a int parameter in C++ file: test_parameter.cpp:2:29"
  "dividend is a int parameter in C++ file: test_parameter.cpp:4:16"
  "divisor is a int parameter in C++ file: test_parameter.cpp:4:30"
  "lable is a char parameter in C++ file: test_parameter.cpp:4:44"
  "src is a std::vector<int> parameter in C++ file: test_parameter.cpp:6:33"
  "copy is a std::vector<int> parameter in C++ file: test_parameter.cpp:6:55"
  "templateTypeByReference is a T & parameter in C++ file: test_parameter.cpp:9:12"
  "x is a const int parameter in C++ file: test_parameter.cpp:11:30"
  "y is a const int parameter in C++ file: test_parameter.cpp:11:43"
  "z is a const int parameter in C++ file: test_parameter.cpp:11:56"
  "num is a long int parameter in C++ file: test_parameter.cpp:15:25"
  "y is a unsigned parameter in C++ file: test_parameter.cpp:15:39"
  "first is a char parameter in C++ file: test_parameter.cpp:17:28"
  "second is a char parameter in C++ file: test_parameter.cpp:17:40"
  "third is a char parameter in C++ file: test_parameter.cpp:17:55"
  "x is a int parameter in C++ file: test_parameter.cpp:21:19"
  "y is a int parameter in C++ file: test_parameter.cpp:21:26"
  "initial is a char parameter in C++ file: test_parameter.cpp:27:28"
  "arr is a char* parameter in C++ file: test_parameter.cpp:30:23"
  "ex is a const std::exception& parameter in C++ file: test_parameter.cpp:34:32"
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
    echo "Got: '$output'"
    exit 1
fi

# Repeat tests

exit 0