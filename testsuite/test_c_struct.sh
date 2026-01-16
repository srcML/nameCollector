#!/bin/bash

cat <<EOF > test_c_struct.c
#include <stdio.h>

struct Point{
    int x;
    int y;
} pointA, pointB = {10,2};  //named point with immediate object declaration collect Point, pointA, pointB

struct MultipleTypes{
    int a;
    float b;
    char c[10];
};

struct Person{
    int age;
    char name[20];
    struct Point location; //nested struct object
};

struct Outer{
    int outerX;
    struct Inner{
        int innerX;
        int innerY;
    } innerPoint;     // internal named struct with internal object
} outward; 

int main(){
    struct Person person1, person2;   // should collect struct objects
    struct Point pointX = {10,11}; 
    struct Point *ptr = &pointX;    // should collect struct pointer
    return 0;
}
EOF

input=$(srcml test_c_struct.c --position)
output=$(echo "$input" | ./nameCollector )
expected="Point is a struct in C file: test_c_struct.c:3:8
x is a int field in C file: test_c_struct.c:4:9
y is a int field in C file: test_c_struct.c:5:9
pointA is a Point global in C file: test_c_struct.c:6:3
pointB is a Point global in C file: test_c_struct.c:6:11
MultipleTypes is a struct in C file: test_c_struct.c:8:8
a is a int field in C file: test_c_struct.c:9:9
b is a float field in C file: test_c_struct.c:10:11
c is a char field in C file: test_c_struct.c:11:10
Person is a struct in C file: test_c_struct.c:14:8
age is a int field in C file: test_c_struct.c:15:9
name is a char field in C file: test_c_struct.c:16:10
location is a struct Point field in C file: test_c_struct.c:17:18
Outer is a struct in C file: test_c_struct.c:20:8
outerX is a int field in C file: test_c_struct.c:21:9
Inner is a struct in C file: test_c_struct.c:22:12
innerX is a int field in C file: test_c_struct.c:23:13
innerY is a int field in C file: test_c_struct.c:24:13
innerPoint is a Inner field in C file: test_c_struct.c:25:7
outward is a Outer global in C file: test_c_struct.c:26:3
main is a int function in C file: test_c_struct.c:28:5
person1 is a struct Person local in C file: test_c_struct.c:29:19
person2 is a struct Person local in C file: test_c_struct.c:29:28
pointX is a struct Point local in C file: test_c_struct.c:30:18
ptr is a struct Point * local in C file: test_c_struct.c:31:19"

expected_struct=(
  "Point is a struct in C file: test_c_struct.c:3:8"
  "pointA is a Point global in C file: test_c_struct.c:6:3"
  "pointB is a Point global in C file: test_c_struct.c:6:11"
  "MultipleTypes is a struct in C file: test_c_struct.c:8:8"
  "Person is a struct in C file: test_c_struct.c:14:8"
  "location is a struct Point field in C file: test_c_struct.c:17:18"
  "Outer is a struct in C file: test_c_struct.c:20:8"
  "Inner is a struct in C file: test_c_struct.c:22:12"
  "innerPoint is a Inner field in C file: test_c_struct.c:25:7"
  "outward is a Outer global in C file: test_c_struct.c:26:3"
  "person1 is a struct Person local in C file: test_c_struct.c:29:19"
  "person2 is a struct Person local in C file: test_c_struct.c:29:28"
  "pointX is a struct Point local in C file: test_c_struct.c:30:18"
  "ptr is a struct Point * local in C file: test_c_struct.c:31:19"
)

for struct in "${expected_struct[@]}"; do
  if ! echo "$output" | grep -Fq "$struct"; then
    echo "Test test_c_struct failed!"
    echo "Expected struct: '$struct' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_c_struct passed!" 

if [[ "$output" != "$expected" ]]; then
    echo "Test test_c_struct output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
# Repeat tests

exit 0