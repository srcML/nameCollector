#!/bin/bash

# Tests templated struct rename in C++

cat <<EOF > test_struct_templated_original.cpp
template<typename T>
struct Box {
};
EOF

cat <<EOF > test_struct_templated_modified.cpp
template<typename T>
struct Container {
};
EOF

input=$(srcdiff test_struct_templated_original.cpp test_struct_templated_modified.cpp --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
T,,template-parameter,test_struct_templated_original.cpp|test_struct_templated_modified.cpp,1:19,C++,
Box|Container,,struct,test_struct_templated_original.cpp|test_struct_templated_modified.cpp,2:8,C++,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_struct_templated output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_struct_templated passed!"

exit 0
