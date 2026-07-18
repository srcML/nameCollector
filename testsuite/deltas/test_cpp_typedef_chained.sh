#!/bin/bash

# Tests chained typedef rename in C++

cat <<EOF > test_typedef_chained_original.cpp
typedef int Int;
typedef Int Count;
EOF

cat <<EOF > test_typedef_chained_modified.cpp
typedef int Int;
typedef Int Total;
EOF

input=$(srcdiff test_typedef_chained_original.cpp test_typedef_chained_modified.cpp --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
Int,int,typedef,test_typedef_chained_original.cpp|test_typedef_chained_modified.cpp,1:13,C++,
Count|Total,Int,typedef,test_typedef_chained_original.cpp|test_typedef_chained_modified.cpp,2:13,C++,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_typedef_chained output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_typedef_chained passed!"

exit 0
