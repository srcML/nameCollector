#!/bin/bash

cat <<EOF > test_c_field.c
#include <stdio.h>
struct Point{ 
    int x, y;
    struct InnerStruct {
        int inner_data_1;
        char inner_data_2;
    } inner_var; 
};

union Union{ 
    int i; 
    float f; 
} u1;

enum Color{ RED, GREEN, BLUE } c = GREEN;

struct Flags {
    unsigned int a : 1;
    unsigned int b : 2;
};

EOF

input=$(srcml test_c_field.c --position)
output=$(echo "$input" | ./nameCollector )
expected="Point is a struct in C file: test_c_field.c:2:8
x is a int field in C file: test_c_field.c:3:9
y is a int field in C file: test_c_field.c:3:12
InnerStruct is a struct in C file: test_c_field.c:4:12
inner_data_1 is a int field in C file: test_c_field.c:5:13
inner_data_2 is a char field in C file: test_c_field.c:6:14
inner_var is a InnerStruct field in C file: test_c_field.c:7:7
Union is a union in C file: test_c_field.c:10:7
i is a int field in C file: test_c_field.c:11:9
f is a float field in C file: test_c_field.c:12:11
u1 is a Union global in C file: test_c_field.c:13:3
Color is a enum in C file: test_c_field.c:15:6
RED is a field in C file: test_c_field.c:15:13
GREEN is a field in C file: test_c_field.c:15:18
BLUE is a field in C file: test_c_field.c:15:25
c is a Color global in C file: test_c_field.c:15:32
Flags is a struct in C file: test_c_field.c:17:8
a is a unsigned int field in C file: test_c_field.c:18:18
b is a unsigned int field in C file: test_c_field.c:19:18"

expected_field=(
  "x is a int field in C file: test_c_field.c:3:9"
  "y is a int field in C file: test_c_field.c:3:12"
  "i is a int field in C file: test_c_field.c:11:9"
  "f is a float field in C file: test_c_field.c:12:11"
  "RED is a field in C file: test_c_field.c:15:13"
  "GREEN is a field in C file: test_c_field.c:15:18"
  "BLUE is a field in C file: test_c_field.c:15:25"
  "a is a unsigned int field in C file: test_c_field.c:18:18"
  "b is a unsigned int field in C file: test_c_field.c:19:18"
  "inner_data_1 is a int field in C file: test_c_field.c:5:13"
  "inner_data_2 is a char field in C file: test_c_field.c:6:14"
  "inner_var is a InnerStruct field in C file: test_c_field.c:7:7"
)

for field in "${expected_field[@]}"; do
  if ! echo "$output" | grep -Fq "$field"; then
    echo "Test test_c_field failed!"
    echo "Expected field: '$field' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_c_field passed!" 

if [[ "$output" != "$expected" ]]; then
    echo "Test test_c_field output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
# Repeat tests

exit 0