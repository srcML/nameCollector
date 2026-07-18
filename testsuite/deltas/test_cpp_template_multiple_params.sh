#!/bin/bash

# Tests renaming multiple template type parameters

cat <<EOF > test_template_multiple_params_original.cpp
template<typename T, typename U>
class Pair {
};
EOF

cat <<EOF > test_template_multiple_params_modified.cpp
template<typename A, typename B>
class Pair {
};
EOF

input=$(srcdiff test_template_multiple_params_original.cpp test_template_multiple_params_modified.cpp --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
T|A,,template-parameter,test_template_multiple_params_original.cpp|test_template_multiple_params_modified.cpp,1:19,C++,
U|B,,template-parameter,test_template_multiple_params_original.cpp|test_template_multiple_params_modified.cpp,1:31,C++,
Pair,,class,test_template_multiple_params_original.cpp|test_template_multiple_params_modified.cpp,2:7,C++,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_template_multiple_params output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_template_multiple_params passed!"

exit 0
