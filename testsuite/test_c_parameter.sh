#!/bin/bash

cat <<EOF > test_c_parameter.c
##include <stdio.h>
// test c parameter

// test with no name, should not collect parameters
int one_parameter(int) { return 0; };
void multiple_parameters(int, int, char) { printf("string"); };

// test with names
void named_parameter(char string[]){
    printf("string %s\n", string);
};

void multiple_named_parameters(float f,  int array[5], char* character){
    printf("multiple: %f, %s", f, character);
    for (int i = 0; i < 5; i++) {
        printf("%d\n", array[i]);
    }
    
}
int main(){
    //just testing name collection no need to call functions
    return 0;
}

EOF

input=$(srcml test_c_parameter.c --position)
output=$(echo "$input" | ./nameCollector )
expected="one_parameter is a int function in C file: test_c_parameter.c:5:5
multiple_parameters is a void function in C file: test_c_parameter.c:6:6
named_parameter is a void function in C file: test_c_parameter.c:9:6
string is a char parameter in C file: test_c_parameter.c:9:27
multiple_named_parameters is a void function in C file: test_c_parameter.c:13:6
f is a float parameter in C file: test_c_parameter.c:13:38
array is a int parameter in C file: test_c_parameter.c:13:46
character is a char* parameter in C file: test_c_parameter.c:13:62
i is a int local in C file: test_c_parameter.c:15:14
main is a int function in C file: test_c_parameter.c:20:5"


expected_parameters=(
    "string is a char parameter in C file: test_c_parameter.c:9:27"
    "f is a float parameter in C file: test_c_parameter.c:13:38"
    "array is a int parameter in C file: test_c_parameter.c:13:46"
    "character is a char* parameter in C file: test_c_parameter.c:13:62"
)

for parameter in "${expected_parameters[@]}"; do
  if ! echo "$output" | grep -Fq "$parameter"; then
    echo "Test test_c_parameter failed!"
    echo "Expected parameter: '$parameter' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_c_parameter passed!" 

if [[ "$output" != "$expected" ]]; then
    echo "Test test_c_parameter output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
# Repeat tests

exit 0