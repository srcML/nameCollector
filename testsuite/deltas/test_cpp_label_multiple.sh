#!/bin/bash

# Tests renaming multiple labels in one function

cat <<EOF > test_label_multiple_original.cpp
void process() {
start:
goto end;
end:
goto start;
}
EOF

cat <<EOF > test_label_multiple_modified.cpp
void process() {
begin:
goto finish;
finish:
goto begin;
}
EOF

input=$(srcdiff test_label_multiple_original.cpp test_label_multiple_modified.cpp --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
process,void,function,test_label_multiple_original.cpp|test_label_multiple_modified.cpp,1:6,C++,
start|begin,,label,test_label_multiple_original.cpp|test_label_multiple_modified.cpp,2:1,C++,
end|finish,,label,test_label_multiple_original.cpp|test_label_multiple_modified.cpp,4:1,C++,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_label_multiple output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_label_multiple passed!"

exit 0
