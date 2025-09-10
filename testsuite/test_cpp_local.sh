#!/bin/bash

# test the collection of local variable names in c++

cat <<EOF > test_local.cpp
#include <vector>
int multiply(int a, int b){
    int return_value = a*b;
    return return_value;
}

// to test that localInsideClassMethod, StaticIntLocal, int nonStaticLocal are categorized as locals and not fields
class Shapes{
    public:

        Shapes();
        Shapes(char): borderCharacter(c) {};

        int calculateArea(int length, int width){ 
            int localInsideClassMethod = length*width; 
            static int StaticIntLocal;
            int nonStaticLocal; 
            return localInsideClassMethod; 
        }; 

    private:
        char borderCharacter; 
};

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
expected="multiply is a int function in C++ file: test_local.cpp:2:5
a is a int parameter in C++ file: test_local.cpp:2:18
b is a int parameter in C++ file: test_local.cpp:2:25
return_value is a int local in C++ file: test_local.cpp:3:9
Shapes is a class in C++ file: test_local.cpp:8:7
Shapes is a constructor in C++ file: test_local.cpp:11:9
Shapes is a constructor in C++ file: test_local.cpp:12:9
calculateArea is a int function in C++ file: test_local.cpp:14:13
length is a int parameter in C++ file: test_local.cpp:14:31
width is a int parameter in C++ file: test_local.cpp:14:43
localInsideClassMethod is a int local in C++ file: test_local.cpp:15:17
StaticIntLocal is a static int local in C++ file: test_local.cpp:16:24
nonStaticLocal is a int local in C++ file: test_local.cpp:17:17
borderCharacter is a char field in C++ file: test_local.cpp:22:14
main is a int function in C++ file: test_local.cpp:25:5
k is a int local in C++ file: test_local.cpp:26:9
j is a int local in C++ file: test_local.cpp:26:16
big_number is a int local in C++ file: test_local.cpp:26:19
product is a int local in C++ file: test_local.cpp:27:9
i is a int local in C++ file: test_local.cpp:29:14
next_one is a int local in C++ file: test_local.cpp:30:13
collection is a std::vector<int> local in C++ file: test_local.cpp:34:22
number is a auto local in C++ file: test_local.cpp:35:14
even is a bool local in C++ file: test_local.cpp:36:33
odd is a bool local in C++ file: test_local.cpp:37:20"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_local failed!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
echo "Test test_cpp_local passed!"
# Repeat tests

exit 0