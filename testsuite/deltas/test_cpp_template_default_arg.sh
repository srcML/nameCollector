#!/bin/bash

# Tests template parameter rename with default argument

cat <<EOF > test_template_default_arg_original.cpp
template<typename T = int>
class Value {
};
EOF

cat <<EOF > test_template_default_arg_modified.cpp
template<typename D = int>
class Value {
};
EOF

input=$(srcdiff test_template_default_arg_original.cpp test_template_default_arg_modified.cpp --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
T|D,,template-parameter,test_template_default_arg_original.cpp|test_template_default_arg_modified.cpp,1:19,C++,
Value,,class,test_template_default_arg_original.cpp|test_template_default_arg_modified.cpp,2:7,C++,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_template_default_arg output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_template_default_arg passed!"

exit 0
