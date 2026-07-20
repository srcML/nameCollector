#!/bin/bash

# tests the collection of class name with changes to the name

cat <<EOF > test_class_name_diff_original.cpp
class foo {
};

EOF

cat <<EOF > test_class_name_diff_modified.cpp
class bar {
};

EOF

input=$(srcdiff test_class_name_diff_original.cpp test_class_name_diff_modified.cpp --position)
output=$(echo "$input" | ./nameCollector --csv)
expected="Name,Type,Category,File,Position,Language,Stereotype
foo|bar,,class,test_class_name_diff_original.cpp|test_class_name_diff_modified.cpp,1:7,C++,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_class_name_diff output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_cpp_class_name_diff passed!"

exit 0
