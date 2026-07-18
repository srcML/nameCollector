#!/bin/bash

# Tests modern C++ using alias rename

cat <<EOF > test_typedef_using_alias_original.cpp
using Count = int;
EOF

cat <<EOF > test_typedef_using_alias_modified.cpp
using Total = int;
EOF

input=$(srcdiff test_typedef_using_alias_original.cpp test_typedef_using_alias_modified.cpp --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
Count|Total,int,typedef,test_typedef_using_alias_original.cpp|test_typedef_using_alias_modified.cpp,1:7,C++,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_typedef_using_alias output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_typedef_using_alias passed!"

exit 0
