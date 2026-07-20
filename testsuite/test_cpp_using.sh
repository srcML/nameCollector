#!/bin/bash

# test the collection of names defined in a using statement

cat <<EOF > test_using.cpp
using alias = ExistingType;

using Vec = vector<int>;

//using FunctionPointer = void(*)(int, double); // srcML errors on this currently

using charArray = char[10];

using STDVec = std::vector<T>;

using std::cout;

using namespace std;

int main(){
    return 0; 
}

EOF

input=$(srcml test_using.cpp --position)
output=$(echo "$input" | ./nameCollector )
expected="alias is a ExistingType typedef in C++ file: test_using.cpp:1:7
Vec is a vector<int> typedef in C++ file: test_using.cpp:3:7
charArray is a char[10] typedef in C++ file: test_using.cpp:7:7
STDVec is a std::vector<T> typedef in C++ file: test_using.cpp:9:7
main is a int function in C++ file: test_using.cpp:15:5"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_using failed!" 
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_cpp_using passed!"
# Repeat tests

exit 0
