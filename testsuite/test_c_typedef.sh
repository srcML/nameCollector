#!/bin/bash

# test the collection of typedef names

cat <<EOF > test_typedef.c
#include <stdio.h>

typedef int Integer;
//anonymous struct
typedef struct {
    int x;
    int y;
} Point; 

//named struct
typedef struct PointAgain{
    int a;
    int b;
} namedStructPoint;

typedef enum Color {
    RED,
    GREEN,
    BLUE
} ColorEnum;

typedef int (*functionPointer)(int, int); 

typedef char* characterArrayPtr;

int add(int x, int y){
    return x+y;
}

int main() {
    Integer num = 10;
    Point p1 = {1, 2};
    namedStructPoint p2 = {3, 4};
    ColorEnum color = RED;
    functionPointer funcPtr = add;
    characterArrayPtr charPtr = "Hello";
    return 0;
}
EOF

input=$(srcml test_typedef.c --position)
output=$(echo "$input" | ./nameCollector )
expected="Integer is a int typedef in C file: test_typedef.c:3:13
x is a int field in C file: test_typedef.c:6:9
y is a int field in C file: test_typedef.c:7:9
Point is a struct { int x; int y; } typedef in C file: test_typedef.c:8:3
PointAgain is a struct in C file: test_typedef.c:11:16
a is a int field in C file: test_typedef.c:12:9
b is a int field in C file: test_typedef.c:13:9
namedStructPoint is a struct PointAgain{ int a; int b; } typedef in C file: test_typedef.c:14:3
Color is a enum in C file: test_typedef.c:16:14
RED is a field in C file: test_typedef.c:17:5
GREEN is a field in C file: test_typedef.c:18:5
BLUE is a field in C file: test_typedef.c:19:5
ColorEnum is a enum Color { RED; GREEN; BLUE } typedef in C file: test_typedef.c:20:3
functionPointer is a int function in C file: test_typedef.c:22:15
characterArrayPtr is a char* typedef in C file: test_typedef.c:24:15
add is a int function in C file: test_typedef.c:26:5
x is a int parameter in C file: test_typedef.c:26:13
y is a int parameter in C file: test_typedef.c:26:20
main is a int function in C file: test_typedef.c:30:5
num is a Integer local in C file: test_typedef.c:31:13
p1 is a Point local in C file: test_typedef.c:32:11
p2 is a namedStructPoint local in C file: test_typedef.c:33:22
color is a ColorEnum local in C file: test_typedef.c:34:15
funcPtr is a functionPointer local in C file: test_typedef.c:35:21
charPtr is a characterArrayPtr local in C file: test_typedef.c:36:23"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_c_typedef failed!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
echo "Test test_c_typedef passed!"
# Repeat tests

exit 0