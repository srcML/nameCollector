#!/bin/bash

# Tests struct rename with bit field members

cat <<EOF > test_struct_bitfields_original.cpp
struct Flags {
int a : 1;
int b : 1;
};
EOF

cat <<EOF > test_struct_bitfields_modified.cpp
struct Options {
int a : 1;
int b : 1;
};
EOF

input=$(srcdiff test_struct_bitfields_original.cpp test_struct_bitfields_modified.cpp --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
Flags|Options,,struct,test_struct_bitfields_original.cpp|test_struct_bitfields_modified.cpp,1:8,C++,
a,int,field,test_struct_bitfields_original.cpp|test_struct_bitfields_modified.cpp,2:5,C++,
b,int,field,test_struct_bitfields_original.cpp|test_struct_bitfields_modified.cpp,3:5,C++,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_struct_bitfields output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_struct_bitfields passed!"

exit 0
