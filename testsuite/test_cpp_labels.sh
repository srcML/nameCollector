#!/bin/bash

# test the collection of named labels, as in goto

cat <<EOF > test_label.cpp
#include<iostream>

int main() {
    // goto label, should collect
    int i=0;
    startOfLoop:
        if (i<10){
            std::cout<< i << std::endl;
            i +=1;
            goto startOfLoop;
        } else {
            goto endOfLoop;
        }

    endOfLoop:
    std::cout<< i << std::endl;

    //switch statement case labels, should not collect 
    switch(i){
        case 10: 
            std::cout<<"loop worked";
            break;
        case 9: 
            std::cout<"uh oh!";
            break;
        default: 
            std::cout <<"how?;
            break; 
    }
    
    return 0; 
}
    

EOF

input=$(srcml test_label.cpp --position)
output=$(echo "$input" | ./nameCollector )
expected="main is a int function in C++ file: test_label.cpp:3:5
i is a int local in C++ file: test_label.cpp:5:9
startOfLoop is a label in C++ file: test_label.cpp:6:5
endOfLoop is a label in C++ file: test_label.cpp:15:5"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_label failed!"
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_cpp_label passed!"
# Repeat tests

exit 0
