#!/bin/bash

# Tests template type parameter rename in C++

cat <<EOF > test_template_parameter_original.cpp
template<typename T>
class Box {
};
EOF

cat <<EOF > test_template_parameter_modified.cpp
template<typename U>
class Box {
};
EOF

input=$(srcdiff test_template_parameter_original.cpp test_template_parameter_modified.cpp --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
T|U,,template-parameter,test_template_parameter_original.cpp|test_template_parameter_modified.cpp,1:20,C++,
Box,,class,test_template_parameter_original.cpp|test_template_parameter_modified.cpp,2:7,C++,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_template_parameter output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_template_parameter passed!"

exit 0
