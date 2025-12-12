#!/bin/bash

# test the collection of union names and union object names

cat <<EOF > test_union.cpp
#include <stdio.h>
union Empty{ };
union Basic {
    int integer_value;
    float float_value;
    char character_value;
};

union ImmediateObject{
    int a;
    int b;
} unionObject; 

union{
    int int_anon_field;
    char char_anon_filed;
} anonObject; 

union Outer{
    int outer_int; 
    union {
        float inner_float;
        char inner_char;
    } inner_anon_field; 
};

struct OuterStruct{
    char charcterArray[10]; 
    union InnerUnion{
        int x;
        int y;
    } inner_union_object; 
    int outer_int_field;
};

int main(){
    return 0; 
};

EOF

input=$(srcml test_union.cpp --position)
output=$(echo "$input" | ./nameCollector )
expected="Empty is a union in C++ file: test_union.cpp:2:7
Basic is a union in C++ file: test_union.cpp:3:7
integer_value is a int field in C++ file: test_union.cpp:4:9
float_value is a float field in C++ file: test_union.cpp:5:11
character_value is a char field in C++ file: test_union.cpp:6:10
ImmediateObject is a union in C++ file: test_union.cpp:9:7
a is a int field in C++ file: test_union.cpp:10:9
b is a int field in C++ file: test_union.cpp:11:9
unionObject is a ImmediateObject global in C++ file: test_union.cpp:12:3
int_anon_field is a int field in C++ file: test_union.cpp:15:9
char_anon_filed is a char field in C++ file: test_union.cpp:16:10
anonObject is a union global in C++ file: test_union.cpp:17:3
Outer is a union in C++ file: test_union.cpp:19:7
outer_int is a int field in C++ file: test_union.cpp:20:9
inner_float is a float field in C++ file: test_union.cpp:22:15
inner_char is a char field in C++ file: test_union.cpp:23:14
inner_anon_field is a union field in C++ file: test_union.cpp:24:7
OuterStruct is a struct in C++ file: test_union.cpp:27:8
charcterArray is a char field in C++ file: test_union.cpp:28:10
InnerUnion is a union in C++ file: test_union.cpp:29:11
x is a int field in C++ file: test_union.cpp:30:13
y is a int field in C++ file: test_union.cpp:31:13
inner_union_object is a InnerUnion field in C++ file: test_union.cpp:32:7
outer_int_field is a int field in C++ file: test_union.cpp:33:9
main is a int function in C++ file: test_union.cpp:36:5"

expected_unions=(
  "Empty is a union in C++ file: test_union.cpp:2:7"
  "Basic is a union in C++ file: test_union.cpp:3:7"
  "ImmediateObject is a union in C++ file: test_union.cpp:9:7"
  "unionObject is a ImmediateObject global in C++ file: test_union.cpp:12:3"
  "anonObject is a union global in C++ file: test_union.cpp:17:3"
  "Outer is a union in C++ file: test_union.cpp:19:7"
  "inner_anon_field is a union field in C++ file: test_union.cpp:24:7"
  "InnerUnion is a union in C++ file: test_union.cpp:29:11"
  "inner_union_object is a InnerUnion field in C++ file: test_union.cpp:32:7"
)

for union in "${expected_unions[@]}"; do
  if ! echo "$output" | grep -Fq "$union"; then
    echo "Test test_c_union failed!"
    echo "Expected union: '$union' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_c_union passed!" # all unions collected correctly

if [[ "$output" != "$expected" ]]; then
    echo "Test test_c_union output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
# Repeat tests

exit 0