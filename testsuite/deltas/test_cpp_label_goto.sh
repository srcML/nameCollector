#!/bin/bash

# Tests label rename used with goto in C++

cat <<EOF > test_label_goto_original.cpp
void process() {
start:
goto start;
}
EOF

cat <<EOF > test_label_goto_modified.cpp
void process() {
begin:
goto begin;
}
EOF

input=$(srcdiff test_label_goto_original.cpp test_label_goto_modified.cpp --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
process,void,function,test_label_goto_original.cpp|test_label_goto_modified.cpp,1:6,C++,
start|begin,,label,test_label_goto_original.cpp|test_label_goto_modified.cpp,2:1,C++,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_label_goto output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_label_goto passed!"

exit 0
