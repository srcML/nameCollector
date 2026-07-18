#!/bin/bash

# Tests typedef name rename in C++

cat <<EOF > test_typedef_rename_original.cpp
typedef int Count;
EOF

cat <<EOF > test_typedef_rename_modified.cpp
typedef int Total;
EOF

input=$(srcdiff test_typedef_rename_original.cpp test_typedef_rename_modified.cpp --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
Count|Total,int,typedef,test_typedef_rename_original.cpp|test_typedef_rename_modified.cpp,1:13,C++,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_typedef_rename output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_typedef_rename passed!"

exit 0
