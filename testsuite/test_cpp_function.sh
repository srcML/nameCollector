#!/bin/bash

# test the collection of global variable names in c++

cat <<EOF > test_function.cpp
// function prototype
char convertAsciiToChar(int acsciiValue);

// function definition
int main(){
    return 0; 
}

// function with recursion
int fibonacci(int n) {
    if (n == 0) {
        return 0;
    } else if (n == 1) {
        return 1;
    }
    else {
        return fibonacci(n - 1) + fibonacci(n - 2);  //should not collect additional name for these
    }
}

//lambda function: categorizes add as an auto global, not as a function or lambda function 
auto add = [](int x, int y) {
    return x+y;
};

//overloaded function: each declaration is counted separately
int multiply(int a, int b);
float multiply(float a, float b); 

EOF

input=$(srcml test_function.cpp --position)
output=$(echo "$input" | ./nameCollector )
expected="convertAsciiToChar is a char function in C++ file: test_function.cpp at 2:6
acsciiValue is a int parameter in C++ file: test_function.cpp at 2:29
main is a int function in C++ file: test_function.cpp at 5:5
fibonacci is a int function in C++ file: test_function.cpp at 10:5
n is a int parameter in C++ file: test_function.cpp at 10:19
add is a auto global in C++ file: test_function.cpp at 22:6
x is a int parameter in C++ file: test_function.cpp at 22:19
y is a int parameter in C++ file: test_function.cpp at 22:26
multiply is a int function in C++ file: test_function.cpp at 27:5
a is a int parameter in C++ file: test_function.cpp at 27:18
b is a int parameter in C++ file: test_function.cpp at 27:25
multiply is a float function in C++ file: test_function.cpp at 28:7
a is a float parameter in C++ file: test_function.cpp at 28:22
b is a float parameter in C++ file: test_function.cpp at 28:31"

expected_functions=(
  "convertAsciiToChar is a char function in C++ file: test_function.cpp at 2:6"
  "main is a int function in C++ file: test_function.cpp at 5:5"
  "fibonacci is a int function in C++ file: test_function.cpp at 10:5"
  "multiply is a int function in C++ file: test_function.cpp at 27:5"
  "multiply is a float function in C++ file: test_function.cpp at 28:7"
)

# make sure contructors are collected correctly in both hpp and cpp files
for function in "${expected_functions[@]}"; do
  if ! echo "$output" | grep -Fq "$function"; then
    echo "Test test_cpp_function failed!"
    echo "Expected function: '$function' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_cpp_function passed!" # all constructor collected correctly

# fail if output does not match expected, even if the constructors are collected correctly
if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_function output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

# Repeat tests

exit 0