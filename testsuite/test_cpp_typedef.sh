#!/bin/bash

# test the collection of typedef names

cat <<EOF > test_typedef.cpp
#include <vector>
typedef int Integer; 
typedef vector<int> int_vector;
typedef char* char_array[5];    //array of char ptr
typedef int (*functionPtr)(int, int);  // with fxn pointer

// with inline struct definitions, named and unamed
typedef struct Point {
    int x, y;
} pt;

typedef struct {
    int v, w;
} anon_struct_typedef;

int main(){
    return 0; 
}

EOF

input=$(srcml test_typedef.cpp --position)
output=$(echo "$input" | ./nameCollector )
expected="Integer is a typedef in C++ file: test_typedef.cpp:2:13
int_vector is a typedef in C++ file: test_typedef.cpp:3:21
char_array is a typedef in C++ file: test_typedef.cpp:4:15
functionPtr is a int function in C++ file: test_typedef.cpp:5:15
Point is a struct in C++ file: test_typedef.cpp:8:16
x is a int field in C++ file: test_typedef.cpp:9:9
y is a int field in C++ file: test_typedef.cpp:9:12
pt is a typedef of struct in C++ file: test_typedef.cpp:10:3
v is a int field in C++ file: test_typedef.cpp:13:9
w is a int field in C++ file: test_typedef.cpp:13:12
anon_struct_typedef is a typedef of struct in C++ file: test_typedef.cpp:14:3
main is a int function in C++ file: test_typedef.cpp:16:5"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_typedef failed!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
echo "Test test_cpp_typedef passed!"
# Repeat tests

exit 0