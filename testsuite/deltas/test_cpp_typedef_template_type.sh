#!/bin/bash

# Tests typedef of a template type in C++

cat <<EOF > test_typedef_template_type_original.cpp
typedef std::vector<int> IntList;
EOF

cat <<EOF > test_typedef_template_type_modified.cpp
typedef std::vector<int> NumList;
EOF

input=$(srcdiff test_typedef_template_type_original.cpp test_typedef_template_type_modified.cpp --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
IntList|NumList,std::vector<int>,typedef,test_typedef_template_type_original.cpp|test_typedef_template_type_modified.cpp,1:26,C++,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_typedef_template_type output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_typedef_template_type passed!"

exit 0
