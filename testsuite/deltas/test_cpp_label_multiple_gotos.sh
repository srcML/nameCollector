#!/bin/bash

# Tests label rename referenced by multiple gotos

cat <<EOF > test_label_multiple_gotos_original.cpp
void process(int x) {
start:
if (x > 0) goto start;
if (x < 0) goto start;
}
EOF

cat <<EOF > test_label_multiple_gotos_modified.cpp
void process(int x) {
begin:
if (x > 0) goto begin;
if (x < 0) goto begin;
}
EOF

input=$(srcdiff test_label_multiple_gotos_original.cpp test_label_multiple_gotos_modified.cpp --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
process,void,function,test_label_multiple_gotos_original.cpp|test_label_multiple_gotos_modified.cpp,1:6,C++,
start|begin,,label,test_label_multiple_gotos_original.cpp|test_label_multiple_gotos_modified.cpp,2:1,C++,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_label_multiple_gotos output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_label_multiple_gotos passed!"

exit 0
