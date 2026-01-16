#!/bin/bash

# tests the collection of class name, only fails is class name is improperly collected or if main is improperly collected

cat <<EOF > test_class_name.cpp
#include <iostream>

class Counter; //testing class forward collection

class Counter{
// empty class to test class name collection
};

//multiple and virtual inheritance
class Base {
    public:
        virtual void foo() = 0;
        virtual void bar() = 0;
};

class Derived1 : public virtual Base {
    public:
        virtual void foo();
};

void Derived1::foo(){ 
    bar(); 
}

class Derived2 : public virtual Base {
    public:
        virtual void bar();
};

class Join : public Derived1, public Derived2 {
    public:
      // ...
};

int main(){
    return 0;
}

EOF

input=$(srcml test_class_name.cpp --position)
output=$(echo "$input" | ./nameCollector )
expected="Counter is a class in C++ file: test_class_name.cpp:3:7
Counter is a class in C++ file: test_class_name.cpp:5:7
Base is a class in C++ file: test_class_name.cpp:10:7
foo is a virtual void function in C++ file: test_class_name.cpp:12:22
bar is a virtual void function in C++ file: test_class_name.cpp:13:22
Derived1 is a class in C++ file: test_class_name.cpp:16:7
foo is a virtual void function in C++ file: test_class_name.cpp:18:22
foo is a void function in C++ file: test_class_name.cpp:21:16
Derived2 is a class in C++ file: test_class_name.cpp:25:7
bar is a virtual void function in C++ file: test_class_name.cpp:27:22
Join is a class in C++ file: test_class_name.cpp:30:7
main is a int function in C++ file: test_class_name.cpp:35:5"

expected_class_names=(
  "Counter is a class in C++ file: test_class_name.cpp:3:7"
  "Counter is a class in C++ file: test_class_name.cpp:5:7"
  "Base is a class in C++ file: test_class_name.cpp:10:7"
  "Derived1 is a class in C++ file: test_class_name.cpp:16:7"
  "Derived2 is a class in C++ file: test_class_name.cpp:25:7"
  "Join is a class in C++ file: test_class_name.cpp:30:7"
)

for class in "${expected_class_names[@]}"; do
  if ! echo "$output" | grep -Fq "$class"; then
    echo "Test test_cpp_class_name failed!"
    echo "Expected enum: '$class' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_cpp_class_name passed!"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_class_name output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
echo "Test test_cpp_class_name passed!"
# Repeat tests

exit 0