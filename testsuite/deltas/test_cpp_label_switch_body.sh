#!/bin/bash

# Tests label rename coexisting with switch/case labels

cat <<EOF > test_label_switch_body_original.cpp
void process(int x) {
done:
switch (x) {
case 1: goto done;
}
}
EOF

cat <<EOF > test_label_switch_body_modified.cpp
void process(int x) {
finished:
switch (x) {
case 1: goto finished;
}
}
EOF

input=$(srcdiff test_label_switch_body_original.cpp test_label_switch_body_modified.cpp --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
process,void,function,test_label_switch_body_original.cpp|test_label_switch_body_modified.cpp,1:6,C++,
done|finished,,label,test_label_switch_body_original.cpp|test_label_switch_body_modified.cpp,2:1,C++,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_label_switch_body output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_label_switch_body passed!"

exit 0
