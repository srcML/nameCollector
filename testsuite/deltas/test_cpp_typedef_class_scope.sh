#!/bin/bash

# Tests typedef scoped inside a class in C++

cat <<EOF > test_typedef_class_scope_original.cpp
class Foo {
typedef int Id;
};
EOF

cat <<EOF > test_typedef_class_scope_modified.cpp
class Foo {
typedef int Key;
};
EOF

input=$(srcdiff test_typedef_class_scope_original.cpp test_typedef_class_scope_modified.cpp --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
Foo,,class,test_typedef_class_scope_original.cpp|test_typedef_class_scope_modified.cpp,1:7,C++,
Id|Key,int,typedef,test_typedef_class_scope_original.cpp|test_typedef_class_scope_modified.cpp,2:13,C++,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_typedef_class_scope output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_typedef_class_scope passed!"

exit 0
