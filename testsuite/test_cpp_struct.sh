#!/bin/bash

# test the collection of struct names and struct object names
# NOTE 7/28/25: struct objects created within the struct definition are misidentified as fields instead of global struct objects
# test will fail until this issue is fixed (issue #22)
# output of struct within typedef definition includes some spacing issue and newline issue

cat <<EOF > test_struct.cpp
struct Cat{
    //empty struct
};

// with accsess specifiers and member function
struct Person{
private:
    int ssn;
public: 
    char* name;
    int age;
    void printAge(){  std::cout<< age << std::endl; };
} person1; //incorrectly called a field

// anonymous struct
struct {
    float field; 
} anonymousStructObject; // incorrectly called a field

// nested structs
struct outer {
    struct inner{
        int a, b;
    } in;
    int q, p;
};

//inside typedef, somethings up here
typedef struct Point {
    int x, y;
} pt;


EOF

input=$(srcml test_struct.cpp --position)
output=$(echo "$input" | ./nameCollector )
expected="Cat is a struct in C++ file: test_struct.cpp at 1:8
Person is a struct in C++ file: test_struct.cpp at 6:8
ssn is a int field in C++ file: test_struct.cpp at 8:9
name is a char* field in C++ file: test_struct.cpp at 10:11
age is a int field in C++ file: test_struct.cpp at 11:9
printAge is a void function in C++ file: test_struct.cpp at 12:10
person1 is a struct Person global in C++ file: test_struct.cpp at 13:3
field is a float field in C++ file: test_struct.cpp at 17:11
anonymousStructObject is a struct { float field; } global in C++ file: test_struct.cpp at 18:3
outer is a struct in C++ file: test_struct.cpp at 21:8
inner is a struct in C++ file: test_struct.cpp at 22:12
a is a int field in C++ file: test_struct.cpp at 23:13
b is a int field in C++ file: test_struct.cpp at 23:16
in is a field in C++ file: test_struct.cpp at 24:7
q is a int field in C++ file: test_struct.cpp at 25:9
p is a int field in C++ file: test_struct.cpp at 25:12
Point is a struct in C++ file: test_struct.cpp at 29:16
x is a int field in C++ file: test_struct.cpp at 30:9
pt is a struct Point {    int x&#44; y;} typedef in C++ file: test_struct.cpp at 31:3"

expected_structs=(
  "Cat is a struct in C++ file: test_struct.cpp at 1:8"
  "Person is a struct in C++ file: test_struct.cpp at 6:8"
  "outer is a struct in C++ file: test_struct.cpp at 21:8"
  "inner is a struct in C++ file: test_struct.cpp at 22:12"
  "Point is a struct in C++ file: test_struct.cpp at 29:16"
)

# test should fail until the issue with srcml parsing structs with immediate obj declarations is resolved
# issue is that these struct objects are incorrectly parsed as fields by SRCML
# issue #22, SRCML issue #2163
# commented out because expected is updated to be the correct output

# problem_with_SRCML_issue_2163=(
#     "person1 is a field in C++ file: test_struct.cpp at 13:3"
#     "anonymousStructObject is a field in C++ file: test_struct.cpp at 18:3"
# )
# for line in "${problem_with_SRCML_issue_2163[@]}"; do
#   if echo "$output" | grep -Fq "$line"; then
#     echo "Test test_cpp_struct failed due to SRCML error!"
#     echo "Some global struct objects are incorrectly collected as fields!"
#     echo "Expected: '$expected'"
#     echo "Got: '$output'"
#     exit 1
#   fi
# done

for struct in "${expected_structs[@]}"; do
  if ! echo "$output" | grep -Fq "$struct"; then
    echo "Test test_cpp_struct failed!"
    echo "Expected struct: '$struct' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_cpp_struct passed!" # all structs collected correctly

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_struct output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
# Repeat tests

exit 0