#!/bin/bash

# test the collection of global and local names definied in expr_stmts

cat <<EOF > test_expr_stmt.py
x = 1
def foo():
    y = 1
x = 2
def a():
    one = 1
    def b():
        one = 1
        two = 2
left = right = None
new_value = __spec__

def test():
    global x
    x = 10

lam = lambda param: param+2
__main__ + "hello"
__main__ += "hello"

def params(p1, p2):
    p0 = None
    p1 = 10
    p2 = p1
    p3 = p2
    def inner():
        nonlocal p1, p2, p3
        p0 = 0
        p1 = 1
        p2 = 2
        p3 = 3
arr = [0]
arr[0] = 10
before = arr[0] = after = 3
t1,t2 = 1,2
(t3,t4) = (1,2)
[t5,t6] = (1,2)
obj.attr = 10
unknown_value[3] = ...
complex.name = ""
longer.complicated.name_value =""

before_comp = 1
[before_comp for before_comp in range(10)]

[after_comp for after_comp in range(10)]
after_comp = 1

EOF

input=$(srcml test_expr_stmt.py --position)
output=$(echo "$input" | ./nameCollector)
expected="x is a global in Python file: test_expr_stmt.py:1:1
foo is a function in Python file: test_expr_stmt.py:2:5
y is a local in Python file: test_expr_stmt.py:3:5
a is a function in Python file: test_expr_stmt.py:5:5
one is a local in Python file: test_expr_stmt.py:6:5
b is a function in Python file: test_expr_stmt.py:7:9
one is a local in Python file: test_expr_stmt.py:8:9
two is a local in Python file: test_expr_stmt.py:9:9
left is a global in Python file: test_expr_stmt.py:10:1
right is a global in Python file: test_expr_stmt.py:10:8
new_value is a global in Python file: test_expr_stmt.py:11:1
test is a function in Python file: test_expr_stmt.py:13:5
lam is a global in Python file: test_expr_stmt.py:17:1
param is a parameter in Python file: test_expr_stmt.py:17:14
params is a function in Python file: test_expr_stmt.py:21:5
p1 is a parameter in Python file: test_expr_stmt.py:21:12
p2 is a parameter in Python file: test_expr_stmt.py:21:16
p0 is a local in Python file: test_expr_stmt.py:22:5
p3 is a local in Python file: test_expr_stmt.py:25:5
inner is a function in Python file: test_expr_stmt.py:26:9
p0 is a local in Python file: test_expr_stmt.py:28:9
arr is a global in Python file: test_expr_stmt.py:32:1
before is a global in Python file: test_expr_stmt.py:34:1
after is a global in Python file: test_expr_stmt.py:34:19
t1 is a global in Python file: test_expr_stmt.py:35:1
t2 is a global in Python file: test_expr_stmt.py:35:4
t3 is a global in Python file: test_expr_stmt.py:36:2
t4 is a global in Python file: test_expr_stmt.py:36:5
t5 is a global in Python file: test_expr_stmt.py:37:2
t6 is a global in Python file: test_expr_stmt.py:37:5
before_comp is a global in Python file: test_expr_stmt.py:43:1
before_comp is a local in Python file: test_expr_stmt.py:44:18
after_comp is a local in Python file: test_expr_stmt.py:46:17
after_comp is a global in Python file: test_expr_stmt.py:47:1"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_py_expr_stmt failed!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
echo "Test test_py_expr_stmt passed!"
# Repeat tests

exit 0
