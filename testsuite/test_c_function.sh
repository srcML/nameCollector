#!/bin/bash

cat <<EOF > test_c_function.c
#include <stdio.h>

// Macro for generic function to mimic function overloading, just collects print as a macro, int, float, const char*, X are not collected
#define print(X) _Generic((X), \
    int: print_int, \
    float: print_float, \
    const char *: print_string \
)(X)

void print_int(int value) {
    printf("Integer: %d\n", value);
} 
void print_float(float value) {
    printf("Float: %f\n", value);
}
void print_string(const char *value) {
    printf("String: %s\n", value);
}

int function_no_parameters() {
    return 0;
}

void function_void_parameters(void){}

void function_with_parameters(int a, float b, double c){}

// forward decl with  no parameter names, not typically allowed in c 
void unamed_parameters(int, float, double);

//function pointer
void (*function_pointer)(void);

int main(){
  
    printf("Hello World");

    return 0;
}

void unamed_parameters(int x, float y, double z){
    printf("you entered: %d %f %f", x, y, z);
}
EOF

input=$(srcml test_c_function.c --position)
output=$(echo "$input" | ./nameCollector )
expected="print is a macro in C file: test_c_function.c:4:9
print_int is a void function in C file: test_c_function.c:6:6
value is a int parameter in C file: test_c_function.c:6:20
print_float is a void function in C file: test_c_function.c:9:6
value is a float parameter in C file: test_c_function.c:9:24
print_string is a void function in C file: test_c_function.c:12:6
value is a const char * parameter in C file: test_c_function.c:12:31
function_no_parameters is a int function in C file: test_c_function.c:16:5
function_void_parameters is a void function in C file: test_c_function.c:20:6
function_with_parameters is a void function in C file: test_c_function.c:22:6
a is a int parameter in C file: test_c_function.c:22:35
b is a float parameter in C file: test_c_function.c:22:44
c is a double parameter in C file: test_c_function.c:22:54
unamed_parameters is a void function in C file: test_c_function.c:25:6
function_pointer is a void function in C file: test_c_function.c:28:8
main is a int function in C file: test_c_function.c:30:5
unamed_parameters is a void function in C file: test_c_function.c:37:6
x is a int parameter in C file: test_c_function.c:37:28
y is a float parameter in C file: test_c_function.c:37:37
z is a double parameter in C file: test_c_function.c:37:47"


expected_functions=(
  "print_int is a void function in C file: test_c_function.c:6:6"
  "print_float is a void function in C file: test_c_function.c:9:6"
  "print_string is a void function in C file: test_c_function.c:12:6"
  "function_no_parameters is a int function in C file: test_c_function.c:16:5"
  "function_void_parameters is a void function in C file: test_c_function.c:20:6"
  "function_with_parameters is a void function in C file: test_c_function.c:22:6"
  "unamed_parameters is a void function in C file: test_c_function.c:25:6"
  "main is a int function in C file: test_c_function.c:30:5"
  "unamed_parameters is a void function in C file: test_c_function.c:37:6"
)

for function in "${expected_functions[@]}"; do
  if ! echo "$output" | grep -Fq "$function"; then
    echo "Test test_c_function failed!"
    echo "Expected field: '$function' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_c_function passed!" 

if [[ "$output" != "$expected" ]]; then
    echo "Test test_c_function output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
# Repeat tests

exit 0