#!/bin/bash

# Tests label rename inside a nested if-block

cat <<EOF > test_label_nested_block_original.cpp
void process() {
if (true) {
retry:
goto retry;
}
}
EOF

cat <<EOF > test_label_nested_block_modified.cpp
void process() {
if (true) {
again:
goto again;
}
}
EOF

input=$(srcdiff test_label_nested_block_original.cpp test_label_nested_block_modified.cpp --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
process,void,function,test_label_nested_block_original.cpp|test_label_nested_block_modified.cpp,1:6,C++,
retry|again,,label,test_label_nested_block_original.cpp|test_label_nested_block_modified.cpp,3:1,C++,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_label_nested_block output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_label_nested_block passed!"

exit 0
