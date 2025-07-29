#!/bin/bash

# test the collection of union names and union object names
# NOTE 7/28/25: union objects created within the union definition are misidentified as fields instead of global struct objects
# test will fail until this issue is fixed (issue #22), message will be "...output did not match expected!"

cat <<EOF > test_union.cpp
union StudentInfo {
    int ID;
    char grade;
    float gpa;
};

union EmployeeInfo {
    int ID_number;
    union Salary {
        float hourly_rate;
        float yearly_salary;
    };
    char section;
};

struct {
    double exists;
    union {
        float a;
        int b;
    };
} structObjectWithAnonymousNestedUnion;

// anonymous union
union {
    int size;
    char print_character;
} shape1; //declaration of multiple on one line breaks main

int main(){
    union EmployeeInfo employee1;
    union StudentInfo student2;

    employee1.hourly_rate = 11.80;

    return 0;
}

EOF

input=$(srcml test_union.cpp --position)
output=$(echo "$input" | ./nameCollector )
expected="StudentInfo is a union in C++ file: test_union.cpp at 1:7
ID is a int field in C++ file: test_union.cpp at 2:9
grade is a char field in C++ file: test_union.cpp at 3:10
gpa is a float field in C++ file: test_union.cpp at 4:11
EmployeeInfo is a union in C++ file: test_union.cpp at 7:7
ID_number is a int field in C++ file: test_union.cpp at 8:9
Salary is a union in C++ file: test_union.cpp at 9:11
hourly_rate is a float field in C++ file: test_union.cpp at 10:15
yearly_salary is a float field in C++ file: test_union.cpp at 11:15
section is a char field in C++ file: test_union.cpp at 13:10
exists is a double field in C++ file: test_union.cpp at 17:12
a is a float field in C++ file: test_union.cpp at 19:15
b is a int field in C++ file: test_union.cpp at 20:13
structObjectWithAnonymousNestedUnion is a struct { double exists; union { float a; int b; }; } global in C++ file: test_union.cpp at 22:3
size is a int field in C++ file: test_union.cpp at 26:9
print_character is a char field in C++ file: test_union.cpp at 27:10
shape1 is a union { int size; char print_character; } global in C++ file: test_union.cpp at 28:3
main is a int function in C++ file: test_union.cpp at 30:5
employee1 is a union EmployeeInfo local in C++ file: test_union.cpp at 31:24
student2 is a union StudentInfo local in C++ file: test_union.cpp at 32:23"

expected_unions=(
  "StudentInfo is a union in C++ file: test_union.cpp at 1:7"
  "EmployeeInfo is a union in C++ file: test_union.cpp at 7:7"
  "Salary is a union in C++ file: test_union.cpp at 9:11"
  "employee1 is a union EmployeeInfo local in C++ file: test_union.cpp at 31:24"
  "student2 is a union StudentInfo local in C++ file: test_union.cpp at 32:23"
)

for union in "${expected_unions[@]}"; do
  if ! echo "$output" | grep -Fq "$union"; then
    echo "Test test_cpp_union failed!"
    echo "Expected union: '$union' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_cpp_union passed!" # all unions collected correctly

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_union output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
# Repeat tests

exit 0