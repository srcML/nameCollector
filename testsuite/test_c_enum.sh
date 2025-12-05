#!/bin/bash

cat <<EOF > test_c_enum.c
#include <stdio.h>
enum Empty { };
enum Colors {RED, YELLOW, BLUE};

int main(){
    return 0; 
}

EOF

input=$(srcml test_c_enum.c --position)
output=$(echo "$input" | ./nameCollector )
expected="Empty is a enum in C file: test_c_enum.c:2:6
Colors is a enum in C file: test_c_enum.c:3:6
RED is a field in C file: test_c_enum.c:3:14
YELLOW is a field in C file: test_c_enum.c:3:19
BLUE is a field in C file: test_c_enum.c:3:27
main is a int function in C file: test_c_enum.c:5:5"

expected_enum=(
  "Empty is a enum in C file: test_c_enum.c:2:6"
  "Colors is a enum in C file: test_c_enum.c:3:6"
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