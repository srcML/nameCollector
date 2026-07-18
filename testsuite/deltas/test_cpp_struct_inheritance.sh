#!/bin/bash

# Tests struct rename with inheritance

cat <<EOF > test_struct_inheritance_original.cpp
struct Base {
};
struct Child : Base {
};
EOF

cat <<EOF > test_struct_inheritance_modified.cpp
struct Base {
};
struct Derived : Base {
};
EOF

input=$(srcdiff test_struct_inheritance_original.cpp test_struct_inheritance_modified.cpp --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
Base,,struct,test_struct_inheritance_original.cpp|test_struct_inheritance_modified.cpp,1:8,C++,
Child|Derived,,struct,test_struct_inheritance_original.cpp|test_struct_inheritance_modified.cpp,3:8,C++,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_struct_inheritance output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_struct_inheritance passed!"

exit 0
