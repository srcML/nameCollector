#!/bin/bash

# Tests template template parameter rename

cat <<EOF > test_template_template_param_original.cpp
template<template<typename> class C>
class Wrapper {
};
EOF

cat <<EOF > test_template_template_param_modified.cpp
template<template<typename> class W>
class Wrapper {
};
EOF

input=$(srcdiff test_template_template_param_original.cpp test_template_template_param_modified.cpp --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
C|W,,template-parameter,test_template_template_param_original.cpp|test_template_template_param_modified.cpp,1:35,C++,
Wrapper,,class,test_template_template_param_original.cpp|test_template_template_param_modified.cpp,2:7,C++,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_template_template_param output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_template_template_param passed!"

exit 0
