#!/bin/bash

cat <<EOF > test_c_local.c
#include <stdio.h>
#include <stdbool.h>

int multiply(int a, int b){
    int return_value = a*b;
    return return_value;
}

int main(){
    int a, b, x;
    float y; 
    char string[20] = "Hello World!";

    { char scoped = 'a'; }

    static int num = 30;
    num++; 

    for (int i = 0; i < 10; i++) {
        int inside_loop = i;
    }

    struct Point { int x, y; } p1 = {1, 2};
    union Union { int i; float f; } u1;
    enum Color { RED, GREEN, BLUE } c = GREEN;
}

EOF

input=$(srcml test_c_local.c --position)
output=$(echo "$input" | ./nameCollector )
expected="multiply is a int function in C file: test_c_local.c:4:5
a is a int parameter in C file: test_c_local.c:4:18
b is a int parameter in C file: test_c_local.c:4:25
return_value is a int local in C file: test_c_local.c:5:9
main is a int function in C file: test_c_local.c:9:5
a is a int local in C file: test_c_local.c:10:9
b is a int local in C file: test_c_local.c:10:12
x is a int local in C file: test_c_local.c:10:15
y is a float local in C file: test_c_local.c:11:11
string is a char local in C file: test_c_local.c:12:10
scoped is a char local in C file: test_c_local.c:14:12
num is a static int local in C file: test_c_local.c:16:16
i is a int local in C file: test_c_local.c:19:14
inside_loop is a int local in C file: test_c_local.c:20:13
Point is a struct in C file: test_c_local.c:23:12
x is a int field in C file: test_c_local.c:23:24
y is a int field in C file: test_c_local.c:23:27
p1 is a Point local in C file: test_c_local.c:23:32
Union is a union in C file: test_c_local.c:24:11
i is a int field in C file: test_c_local.c:24:23
f is a float field in C file: test_c_local.c:24:32
u1 is a Union local in C file: test_c_local.c:24:37
Color is a enum in C file: test_c_local.c:25:10
RED is a field in C file: test_c_local.c:25:18
GREEN is a field in C file: test_c_local.c:25:23
BLUE is a field in C file: test_c_local.c:25:30
c is a Color local in C file: test_c_local.c:25:37"

expected_local=(
  "return_value is a int local in C file: test_c_local.c:5:9"
  "a is a int local in C file: test_c_local.c:10:9"
  "b is a int local in C file: test_c_local.c:10:12"
  "x is a int local in C file: test_c_local.c:10:15"
  "y is a float local in C file: test_c_local.c:11:11"
  "string is a char local in C file: test_c_local.c:12:10"
  "scoped is a char local in C file: test_c_local.c:14:12"
  "num is a static int local in C file: test_c_local.c:16:16"
  "i is a int local in C file: test_c_local.c:19:14"
  "inside_loop is a int local in C file: test_c_local.c:20:13"
  "p1 is a Point local in C file: test_c_local.c:23:32"
  "u1 is a Union local in C file: test_c_local.c:24:37"
  "c is a Color local in C file: test_c_local.c:25:37"
)

for local in "${expected_local[@]}"; do
  if ! echo "$output" | grep -Fq "$local"; then
    echo "Test test_c_local failed!"
    echo "Expected local: '$local' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_c_local passed!" 

if [[ "$output" != "$expected" ]]; then
    echo "Test test_c_local output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
# Repeat tests

exit 0