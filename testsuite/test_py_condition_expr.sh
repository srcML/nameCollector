#!/bin/bash

# test the collection of global and local names definied in condition_exprs

cat <<EOF > test_condition_expr.py
if x := 10:
    print(x)

if (y := 10) and (z := 20):
    print(y,z)

if p and (a := 10) and (b := 20):
    print(a,b)

def foo(t):
    if x := 10:
        print(x)

    if (y := 10) and (z := 20):
        print(y,z)

    if p and (a := 10) and (b := 20):
        print(a,b)

    if t := 10:
        print(t)

    def inner():
        global x, y, z
        nonlocal a, b, t
        if x := 10:
            print(x)

        if (y := 10) and (z := 20):
            print(y,z)

        if p and (a := 10) and (b := 20):
            print(a,b)

        if t := 10:
            print(t)

while loop := True
    break

while (line := getline()) is not None:
    process(line)

for i in range(10):
    print(i)

def for_test():
    for j in range(20):
        print(j)

for left, right in arr:
    print(left + right)

EOF

input=$(srcml test_condition_expr.py --position)
output=$(echo "$input" | ./nameCollector)
expected="x is a global in Python file: test_condition_expr.py:1:4
y is a global in Python file: test_condition_expr.py:4:5
z is a global in Python file: test_condition_expr.py:4:19
a is a global in Python file: test_condition_expr.py:7:11
b is a global in Python file: test_condition_expr.py:7:25
foo is a function in Python file: test_condition_expr.py:10:5
t is a parameter in Python file: test_condition_expr.py:10:9
x is a local in Python file: test_condition_expr.py:11:8
y is a local in Python file: test_condition_expr.py:14:9
z is a local in Python file: test_condition_expr.py:14:23
a is a local in Python file: test_condition_expr.py:17:15
b is a local in Python file: test_condition_expr.py:17:29
inner is a function in Python file: test_condition_expr.py:23:9
loop is a global in Python file: test_condition_expr.py:38:7
line is a global in Python file: test_condition_expr.py:41:8
i is a global in Python file: test_condition_expr.py:44:5
for_test is a function in Python file: test_condition_expr.py:47:5
j is a local in Python file: test_condition_expr.py:48:9
left is a global in Python file: test_condition_expr.py:51:5
right is a global in Python file: test_condition_expr.py:51:11"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_py_condition_expr failed!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
echo "Test test_py_condition_expr passed!"
# Repeat tests

exit 0
