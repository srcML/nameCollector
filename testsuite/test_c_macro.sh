#!/bin/bash

cat <<EOF > test_c_macro.c
#include <stdio.h>
#include <string.h>
#define MAX_SIZE 100
#define SQUARE(x) ((x) * (x))
#define STR "test"
//multiline macro
#define MULTI(num, str) {       \
		    printf("%d", num);  \
		    printf(" %s", str); \
        }                       \

int main(){
    MULTI(8, "string"); 
    return 0; 
}
EOF

input=$(srcml test_c_macro.c --position)
output=$(echo "$input" | ./nameCollector )
expected="MAX_SIZE is a macro in C file: test_c_macro.c:3:9
SQUARE is a macro in C file: test_c_macro.c:4:9
STR is a macro in C file: test_c_macro.c:5:9
MULTI is a macro in C file: test_c_macro.c:7:9
main is a int function in C file: test_c_macro.c:8:5"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_c_macro output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
# Repeat tests

exit 0