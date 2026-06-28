#!/bin/bash

cat <<EOF > test_c_function_parameter.c
#include <stdio.h>
// passing function pointers
void function_with_function_parameter ( int (*f)(int, int) ) {
    int result;
    for ( int ctr = 0 ; ctr < 5 ; ctr++ ) {
        result = (*f)(ctr, (ctr+1));
        printf("result: %d\n", result);
    }
}

int add(int x, int y){
  return x+y; 
}

void pass_function_with_multiple_parameters(void (*fxnPointer)(float, int, double)) {};
void function_with_multiple_parameters(int (*fxnPointer2)(int, char), char, float) {};
void function_with_multiple_function_parameters(int (*fxnPointerA)(int), char (*fxnPointerB)(char), void (*fxnPointerC)(float)) {};
int main(){
    function_with_function_parameter(add);
    return 0;
}

EOF

input=$(srcml test_c_function_parameter.c --position)
output=$(echo "$input" | ./nameCollector )
expected="function_with_function_parameter is a void function in C file: test_c_function_parameter.c:3:6
f is a function-parameter in C file: test_c_function_parameter.c:3:47
result is a int local in C file: test_c_function_parameter.c:4:9
ctr is a int local in C file: test_c_function_parameter.c:5:15
add is a int function in C file: test_c_function_parameter.c:11:5
x is a int parameter in C file: test_c_function_parameter.c:11:13
y is a int parameter in C file: test_c_function_parameter.c:11:20
pass_function_with_multiple_parameters is a void function in C file: test_c_function_parameter.c:15:6
fxnPointer is a function-parameter in C file: test_c_function_parameter.c:15:52
function_with_multiple_parameters is a void function in C file: test_c_function_parameter.c:16:6
fxnPointer2 is a function-parameter in C file: test_c_function_parameter.c:16:46
function_with_multiple_function_parameters is a void function in C file: test_c_function_parameter.c:17:6
fxnPointerA is a function-parameter in C file: test_c_function_parameter.c:17:55
fxnPointerB is a function-parameter in C file: test_c_function_parameter.c:17:81
fxnPointerC is a function-parameter in C file: test_c_function_parameter.c:17:108
main is a int function in C file: test_c_function_parameter.c:18:5"


expected_function_parameters=(
    "f is a function-parameter in C file: test_c_function_parameter.c:3:47"
    "fxnPointer is a function-parameter in C file: test_c_function_parameter.c:15:52"
    "fxnPointer2 is a function-parameter in C file: test_c_function_parameter.c:16:46"
    "fxnPointerA is a function-parameter in C file: test_c_function_parameter.c:17:55"
    "fxnPointerB is a function-parameter in C file: test_c_function_parameter.c:17:81"
    "fxnPointerC is a function-parameter in C file: test_c_function_parameter.c:17:108"
)

for function_parameter in "${expected_function_parameters[@]}"; do
  if ! echo "$output" | grep -Fq "$function_parameter"; then
    echo "Test test_c_function_parameter failed!"
    echo "Expected function_parameter: '$function_parameter' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_c_function_parameter passed!" 

if [[ "$output" != "$expected" ]]; then
    echo "Test test_c_function_parameter output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
# Repeat tests

exit 0