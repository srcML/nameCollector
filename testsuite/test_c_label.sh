#!/bin/bash

cat <<EOF > test_c_label.c
#include <stdio.h>

int main(){
    int x=5;
    if(x == 6){
        goto conditionA;
    } else if(x > 6){
        goto conditonB;
    } else{
        goto conditionC; 
    }

    conditionA:
        printf("conditonA");
        goto end;
    conditonB:
        printf("conditonB");
        goto end;
    conditionC:
        printf("conditonC");
        goto end; 
    end:
        printf("\n");
        return 0;
}
EOF

input=$(srcml test_c_label.c --position)
output=$(echo "$input" | ./nameCollector )
expected="main is a int function in C file: test_c_label.c:3:5
x is a int local in C file: test_c_label.c:4:9
conditionA is a label in C file: test_c_label.c:13:5
conditonB is a label in C file: test_c_label.c:16:5
conditionC is a label in C file: test_c_label.c:19:5
end is a label in C file: test_c_label.c:22:5"

expected_label=(
  "conditionA is a label in C file: test_c_label.c:13:5"
  "conditonB is a label in C file: test_c_label.c:16:5"
  "conditionC is a label in C file: test_c_label.c:19:5"
  "end is a label in C file: test_c_label.c:22:5"
)

for label in "${expected_label[@]}"; do
  if ! echo "$output" | grep -Fq "$label"; then
    echo "Test test_c_label failed!"
    echo "Expected label: '$label' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_c_label passed!" 

if [[ "$output" != "$expected" ]]; then
    echo "Test test_c_label output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
# Repeat tests

exit 0