#!/bin/bash

# test the collection of typedef names

cat <<EOF > test_typedef.py
type URL = str
type IntList = list[int]
type ListOrSet[T] = list[T] | set[T]
EOF

input=$(srcml test_typedef.py --position)
output=$(echo "$input" | ./nameCollector )
expected="URL is a typedef in Python file: test_typedef.py:1:6
IntList is a typedef in Python file: test_typedef.py:2:6
ListOrSet is a typedef in Python file: test_typedef.py:3:6
T is a template-parameter in Python file: test_typedef.py:3:16"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_py_typedef failed!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
echo "Test test_py_typedef passed!"
# Repeat tests

exit 0
