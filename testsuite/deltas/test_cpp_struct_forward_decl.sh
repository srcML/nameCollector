#!/bin/bash

# Tests forward-declared struct rename in C++

cat <<EOF > test_struct_forward_decl_original.cpp
struct Point;
struct Point {
int x;
};
EOF

cat <<EOF > test_struct_forward_decl_modified.cpp
struct Coord;
struct Coord {
int x;
};
EOF

input=$(srcdiff test_struct_forward_decl_original.cpp test_struct_forward_decl_modified.cpp --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
Point|Coord,,struct,test_struct_forward_decl_original.cpp|test_struct_forward_decl_modified.cpp,1:8,C++,
Point|Coord,,struct,test_struct_forward_decl_original.cpp|test_struct_forward_decl_modified.cpp,2:8,C++,
x,int,field,test_struct_forward_decl_original.cpp|test_struct_forward_decl_modified.cpp,3:5,C++,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_struct_forward_decl output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_struct_forward_decl passed!"

exit 0
