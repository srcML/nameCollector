#!/bin/bash

# test the collection of local variable names in c++

cat <<EOF > test_local.cpp
int multiply(int a, int b){
    int return_value = a*b;
    return return_value;
}

int main(){
    int k = 8, j, big_number;
    int product = multiply(10, 12);

    for( int i=0; i < 18; i++){
        int next_one = i+1; 
        big_number = multiply(i, next_one);
    }
    return 0;
}

EOF

input=$(srcml test_local.cpp --position)
output=$(echo "$input" | ./nameCollector )
expected="multiply is a int function in C++ file: test_local.cpp at 1:5
a is a int parameter in C++ file: test_local.cpp at 1:18
b is a int parameter in C++ file: test_local.cpp at 1:25
return_value is a int local in C++ file: test_local.cpp at 2:9
main is a int function in C++ file: test_local.cpp at 6:5
k is a int local in C++ file: test_local.cpp at 7:9
j is a int local in C++ file: test_local.cpp at 7:16
big_number is a int local in C++ file: test_local.cpp at 7:19
product is a int local in C++ file: test_local.cpp at 8:9
i is a int local in C++ file: test_local.cpp at 10:14
next_one is a int local in C++ file: test_local.cpp at 11:13"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_local failed!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

# Repeat tests

exit 0