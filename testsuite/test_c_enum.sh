#!/bin/bash

cat <<EOF > test_c_enum.c
#include <stdio.h>
enum Colors {RED, YELLOW, BLUE};
// with assigned value to one
enum Difficulty {EASY = 1, MEDIUM, HARD}; 
// with all assigned value
enum Values {FIRST = 1, SECOND = 2, FOURTH = 4 };
// anon and immediate declaration
enum {ON = 1, OFF = 0} light = OFF; 

int main(){
    enum Colors myColor;
    enum Values myValue = SECOND; 
    return 0; 
}

EOF

input=$(srcml test_c_enum.c --position)
output=$(echo "$input" | ./nameCollector )
expected="Colors is a enum in C file: test_c_enum.c:2:6
RED is a field in C file: test_c_enum.c:2:14
YELLOW is a field in C file: test_c_enum.c:2:19
BLUE is a field in C file: test_c_enum.c:2:27
Difficulty is a enum in C file: test_c_enum.c:4:6
EASY is a field in C file: test_c_enum.c:4:18
MEDIUM is a field in C file: test_c_enum.c:4:28
HARD is a field in C file: test_c_enum.c:4:36
Values is a enum in C file: test_c_enum.c:6:6
FIRST is a field in C file: test_c_enum.c:6:14
SECOND is a field in C file: test_c_enum.c:6:25
FOURTH is a field in C file: test_c_enum.c:6:37
ON is a field in C file: test_c_enum.c:8:7
OFF is a field in C file: test_c_enum.c:8:15
light is a enum global in C file: test_c_enum.c:8:24
main is a int function in C file: test_c_enum.c:10:5
myColor is a enum Colors local in C file: test_c_enum.c:11:17
myValue is a enum Values local in C file: test_c_enum.c:12:17"

expected_enum=(
  "Colors is a enum in C file: test_c_enum.c:2:6"
  "Difficulty is a enum in C file: test_c_enum.c:4:6"
  "Values is a enum in C file: test_c_enum.c:6:6"
  "light is a enum global in C file: test_c_enum.c:8:24"
  "myColor is a enum Colors local in C file: test_c_enum.c:11:17"
  "myValue is a enum Values local in C file: test_c_enum.c:12:17"
)

for enum in "${expected_enum[@]}"; do
  if ! echo "$output" | grep -Fq "$enum"; then
    echo "Test test_c_enum failed!"
    echo "Expected enum: '$enum' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_c_enum passed!" 

if [[ "$output" != "$expected" ]]; then
    echo "Test test_c_enum output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
# Repeat tests

exit 0