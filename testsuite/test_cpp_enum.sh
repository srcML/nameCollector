#!/bin/bash

# test the collection ofenum names and enum object names

cat <<EOF > test_enum.cpp
//empty enum
enum empty_enum { /*empty*/ };

//enum with no assigned values to variables, fields have no type 
enum Direction { NORTH, SOUTH, EAST, WEST };

//enum objects with assignment and no assignment
Direction current_direction; 
Direction past_direction = NORTH; 

//enum with manual assignment and immediate object declaration 
enum Color { RED = 3, ORANGE = 5, YELLOW = 7 } past_color = ORANGE;

//enum class 
enum class Day { Sunday = 1, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday };

//enum class with immediate object declaration 
enum class Week { Sunday = 1, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday } days;

//test enum with type
enum TypedWeek:size_t { S = 1, M, T, W };

//anonymous enum with immediate object declaration 
enum {ON = 1, OFF = 0} status = OFF; 

int main(){
    //enum object declaration inside main 
    Color current_color = RED; 
    //enum defined inside a function with immediate object declaration 
    enum Fruit { APPLE, ORANGE, PEACH } fruits; //fields are called locals, fruits is called int local
    return 0; 
}
EOF

input=$(srcml test_enum.cpp --position)
output=$(echo "$input" | ./nameCollector )
expected="empty_enum is a enum in C++ file: test_enum.cpp:2:6
Direction is a enum in C++ file: test_enum.cpp:5:6
NORTH is a field in C++ file: test_enum.cpp:5:18
SOUTH is a field in C++ file: test_enum.cpp:5:25
EAST is a field in C++ file: test_enum.cpp:5:32
WEST is a field in C++ file: test_enum.cpp:5:38
current_direction is a Direction global in C++ file: test_enum.cpp:8:11
past_direction is a Direction global in C++ file: test_enum.cpp:9:11
Color is a enum in C++ file: test_enum.cpp:12:6
RED is a field in C++ file: test_enum.cpp:12:14
ORANGE is a field in C++ file: test_enum.cpp:12:23
YELLOW is a field in C++ file: test_enum.cpp:12:35
past_color is a Color global in C++ file: test_enum.cpp:12:48
Day is a enum in C++ file: test_enum.cpp:15:12
Sunday is a field in C++ file: test_enum.cpp:15:18
Monday is a field in C++ file: test_enum.cpp:15:30
Tuesday is a field in C++ file: test_enum.cpp:15:38
Wednesday is a field in C++ file: test_enum.cpp:15:47
Thursday is a field in C++ file: test_enum.cpp:15:58
Friday is a field in C++ file: test_enum.cpp:15:68
Saturday is a field in C++ file: test_enum.cpp:15:76
Week is a enum in C++ file: test_enum.cpp:18:12
Sunday is a field in C++ file: test_enum.cpp:18:19
Monday is a field in C++ file: test_enum.cpp:18:31
Tuesday is a field in C++ file: test_enum.cpp:18:39
Wednesday is a field in C++ file: test_enum.cpp:18:48
Thursday is a field in C++ file: test_enum.cpp:18:59
Friday is a field in C++ file: test_enum.cpp:18:69
Saturday is a field in C++ file: test_enum.cpp:18:77
days is a Week global in C++ file: test_enum.cpp:18:88
TypedWeek is a enum in C++ file: test_enum.cpp:21:6
S is a size_t field in C++ file: test_enum.cpp:21:25
M is a size_t field in C++ file: test_enum.cpp:21:32
T is a size_t field in C++ file: test_enum.cpp:21:35
W is a size_t field in C++ file: test_enum.cpp:21:38
ON is a field in C++ file: test_enum.cpp:24:7
OFF is a field in C++ file: test_enum.cpp:24:15
status is a enum global in C++ file: test_enum.cpp:24:24
main is a int function in C++ file: test_enum.cpp:26:5
current_color is a Color local in C++ file: test_enum.cpp:28:11
Fruit is a enum in C++ file: test_enum.cpp:30:10
APPLE is a int local in C++ file: test_enum.cpp:30:18
ORANGE is a int local in C++ file: test_enum.cpp:30:25
PEACH is a int local in C++ file: test_enum.cpp:30:33
fruits is a Fruit local in C++ file: test_enum.cpp:30:41"

expected_enums=(
  "empty_enum is a enum in C++ file: test_enum.cpp:2:6"
  "Direction is a enum in C++ file: test_enum.cpp:5:6"
  "current_direction is a Direction global in C++ file: test_enum.cpp:8:11"
  "past_direction is a Direction global in C++ file: test_enum.cpp:9:11"
  "Color is a enum in C++ file: test_enum.cpp:12:6"
  "past_color is a Color global in C++ file: test_enum.cpp:12:48"
  "Day is a enum in C++ file: test_enum.cpp:15:12"
  "Week is a enum in C++ file: test_enum.cpp:18:12"
  "days is a Week global in C++ file: test_enum.cpp:18:88"
  "current_color is a Color local in C++ file: test_enum.cpp:23:11"
  "Fruit is a enum in C++ file: test_enum.cpp:25:10"
  "fruits is a Fruit local in C++ file: test_enum.cpp:25:41"
  "status is a enum global in C++ file: test_enum.cpp:21:24"
)

for enum in "${expected_enums[@]}"; do
  if ! echo "$output" | grep -Fq "$enum"; then
    echo "Test test_cpp_enum failed!"
    echo "Expected enum: '$enum' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_cpp_enum passed!" # all enums collected correctly

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_enum output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
# Repeat tests

exit 0