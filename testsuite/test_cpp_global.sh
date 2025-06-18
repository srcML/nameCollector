#!/bin/bash

# test the collection of global variable names in c++

cat <<EOF > test_global.cpp
int global_int=55;
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

EOF

input=$(srcml test_global.cpp --position)
# input=$(cat <<EOF
# <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
# <unit xmlns="http://www.srcML.org/srcML/src" revision="1.0.0" language="C++" filename="test.cpp">
# <decl_stmt><decl><type><name>int</name></type> <name>y</name></decl>;</decl_stmt>
# </unit>
# EOF
# )
output=$(echo "$input" | ./nameCollector )
expected="global_int is a int global in C++ file: test_global.cpp at 1:5
global_int_E is a extern int global in C++ file: test_global.cpp at 2:12
global_int_S is a static int global in C++ file: test_global.cpp at 3:12
global_bool is a bool global in C++ file: test_global.cpp at 4:6
global_float is a float global in C++ file: test_global.cpp at 5:7
global_char is a char global in C++ file: test_global.cpp at 6:6
a is a char global in C++ file: test_global.cpp at 6:19
b is a char global in C++ file: test_global.cpp at 6:22
globalPtr is a int * global in C++ file: test_global.cpp at 8:6
MyClass is a class in C++ file: test_global.cpp at 10:7
field is a int field in C++ file: test_global.cpp at 11:9
globalMyClassObj is a MyClass global in C++ file: test_global.cpp at 13:9
T is a template-parameter in C++ file: test_global.cpp at 14:19
globalTemplateVar is a T global in C++ file: test_global.cpp at 15:3
MyCatsInitials is a namespace in C++ file: test_global.cpp at 17:11
murphy is a char global in C++ file: test_global.cpp at 18:10
peanut is a char global in C++ file: test_global.cpp at 19:10"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_global failed!"
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi

# Repeat tests

exit 0
