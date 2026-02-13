#!/bin/bash

cat <<EOF > test_c_label.c
#include <stdio.h>
// label defined in macro
#define LABEL(a){                    \
    __label__ one, two, exit;        \
    if(a==2){                        \
        goto two;                    \
    } else {                         \
        goto one;                    \
    }                                \
    two:                             \
        printf("input is two");      \
        goto exit;                   \
    one:                             \
        printf("input is not two");  \
        goto exit;                   \
    exit: printf("");                \
}                                    \
 

// basic form __label__ label_name.
// goto label_name
// label_name: {code}

int main(){
    // local labels
    __label__ conditionA, conditionB, conditionC;
    int x=5;
    if(x == 6){
        goto conditionA;
    } else if(x > 6){
        goto conditonB;
    } else{
        goto conditionC; 
    }
    // nested labels, one without a forward declaration
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
        LABEL(2);
        return 0;
}
EOF

input=$(srcml test_c_label.c --position)
output=$(echo "$input" | ./nameCollector )
expected="LABEL is a macro in C file: test_c_label.c:3:9
main is a int function in C file: test_c_label.c:9:5
conditionA is a __label__ local in C file: test_c_label.c:11:15
conditionB is a __label__ local in C file: test_c_label.c:11:27
conditionC is a __label__ local in C file: test_c_label.c:11:39
x is a int local in C file: test_c_label.c:12:9
conditionA is a label in C file: test_c_label.c:21:5
conditonB is a label in C file: test_c_label.c:24:5
conditionC is a label in C file: test_c_label.c:27:5
end is a label in C file: test_c_label.c:30:5"

expected_label=(
  "conditionA is a label in C file: test_c_label.c:21:5"
  "conditonB is a label in C file: test_c_label.c:24:5"
  "conditionC is a label in C file: test_c_label.c:27:5"
  "end is a label in C file: test_c_label.c:30:5"
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