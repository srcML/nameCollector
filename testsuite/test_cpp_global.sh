#!/bin/bash

# test the collection of global variable names in c++

cat <<EOF > test_global.cpp
int global_int=55;
long int global_long;
short global_short;
unsigned char global_unsigned_char;
extern int global_int_E;
static int global_int_S;
bool global_bool;
float global_float;
char global_char, a, b;
// test pointers
int *globalPtr;
// test global objects and template typed objects
class MyClass{
    int field;
};
MyClass globalMyClassObj; 
template<typename T>
T globalTemplateVar;
// test namespace variables, variables in namespace should be global
namespace MyCatsInitials{
    char murphy= 'M';
    char peanut= 'P';
}
int main(){
    return 0;
}

EOF

input=$(srcml test_global.cpp --position)
output=$(echo "$input" | ./nameCollector )
expected="global_int is a int global in C++ file: test_global.cpp:1:5
global_long is a long int global in C++ file: test_global.cpp:2:10
global_short is a short global in C++ file: test_global.cpp:3:7
global_unsigned_char is a unsigned char global in C++ file: test_global.cpp:4:15
global_int_E is a extern int global in C++ file: test_global.cpp:5:12
global_int_S is a static int global in C++ file: test_global.cpp:6:12
global_bool is a bool global in C++ file: test_global.cpp:7:6
global_float is a float global in C++ file: test_global.cpp:8:7
global_char is a char global in C++ file: test_global.cpp:9:6
a is a char global in C++ file: test_global.cpp:9:19
b is a char global in C++ file: test_global.cpp:9:22
globalPtr is a int * global in C++ file: test_global.cpp:11:6
MyClass is a class in C++ file: test_global.cpp:13:7
field is a int field in C++ file: test_global.cpp:14:9
globalMyClassObj is a MyClass global in C++ file: test_global.cpp:16:9
T is a template-parameter in C++ file: test_global.cpp:17:19
globalTemplateVar is a T global in C++ file: test_global.cpp:18:3
MyCatsInitials is a namespace in C++ file: test_global.cpp:20:11
murphy is a char global in C++ file: test_global.cpp:21:10
peanut is a char global in C++ file: test_global.cpp:22:10
main is a int function in C++ file: test_global.cpp:24:5"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_global failed!"
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_cpp_global passed!"
# Repeat tests

exit 0
