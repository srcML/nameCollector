#!/bin/bash

# Tests nested struct rename in C++

cat <<EOF > test_struct_nested_original.cpp
struct Outer {
struct Inner {
};
};
EOF

cat <<EOF > test_struct_nested_modified.cpp
struct Container {
struct Nested {
};
};
EOF

input=$(srcdiff test_struct_nested_original.cpp test_struct_nested_modified.cpp --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
Outer|Container,,struct,test_struct_nested_original.cpp|test_struct_nested_modified.cpp,1:8,C++,
Inner|Nested,,struct,test_struct_nested_original.cpp|test_struct_nested_modified.cpp,2:8,C++,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_struct_nested output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_struct_nested passed!"

exit 0
