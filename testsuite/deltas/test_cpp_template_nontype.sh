#!/bin/bash

# Tests non-type template parameter rename

cat <<EOF > test_template_nontype_original.cpp
template<int N>
class Array {
};
EOF

cat <<EOF > test_template_nontype_modified.cpp
template<int Size>
class Array {
};
EOF

input=$(srcdiff test_template_nontype_original.cpp test_template_nontype_modified.cpp --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
N|Size,int,template-parameter,test_template_nontype_original.cpp|test_template_nontype_modified.cpp,1:14,C++,
Array,,class,test_template_nontype_original.cpp|test_template_nontype_modified.cpp,2:7,C++,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_template_nontype output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_template_nontype passed!"

exit 0
