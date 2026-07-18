#!/bin/bash

# Tests variadic template parameter rename

cat <<EOF > test_template_variadic_original.cpp
template<typename... Args>
class Tuple {
};
EOF

cat <<EOF > test_template_variadic_modified.cpp
template<typename... Params>
class Tuple {
};
EOF

input=$(srcdiff test_template_variadic_original.cpp test_template_variadic_modified.cpp --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
Args|Params,,template-parameter,test_template_variadic_original.cpp|test_template_variadic_modified.cpp,1:22,C++,
Tuple,,class,test_template_variadic_original.cpp|test_template_variadic_modified.cpp,2:7,C++,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_template_variadic output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_template_variadic passed!"

exit 0
