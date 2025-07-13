#!/bin/bash

# test the collection of local variable names in c++

cat <<EOF > test_local.cpp
#include <vector>
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
    //nested locals
    std::vector<int> collection = {1, 2, 3};
    for(auto number:collection){
        if(number%2 == 0){ bool even = true; }
        else {bool odd = false; }
    }
    return 0; 
}

EOF

input=$(srcml test_local.cpp --position)
output=$(echo "$input" | ./nameCollector )
expected="multiply is a int function in C++ file: test_local.cpp at 2:5
a is a int parameter in C++ file: test_local.cpp at 2:18
b is a int parameter in C++ file: test_local.cpp at 2:25
return_value is a int local in C++ file: test_local.cpp at 3:9
main is a int function in C++ file: test_local.cpp at 7:5
k is a int local in C++ file: test_local.cpp at 8:9
j is a int local in C++ file: test_local.cpp at 8:16
big_number is a int local in C++ file: test_local.cpp at 8:19
product is a int local in C++ file: test_local.cpp at 9:9
i is a int local in C++ file: test_local.cpp at 11:14
next_one is a int local in C++ file: test_local.cpp at 12:13
collection is a std::vector<int> local in C++ file: test_local.cpp at 16:22
number is a auto local in C++ file: test_local.cpp at 17:14
even is a bool local in C++ file: test_local.cpp at 18:33
odd is a bool local in C++ file: test_local.cpp at 19:20"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_local failed!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
echo "Test test_cpp_local passed!"
# Repeat tests

exit 0