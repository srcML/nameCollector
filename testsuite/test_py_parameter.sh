#!/bin/bash

# test the collection of parameter names in c++

cat <<EOF > test_parameter.py
# No parameters
def test1():
    pass

# One parameter
def test2(a):
    pass

# Two parameters
def test3(a,b):
    pass

# Three parameters
def test4(a,b,c):
    pass

# Init parameters
def test5(a = b):
    pass

# Modifier parameters
def test6(a,/,b,*,c):
    pass

# Arg parameters
def test7(*args, **kwargs):
    pass

# Template parameters
def test8[T]():
    pass

# Annotated parameters
def test9(a:int, b:x, c:"Hello"):
    pass

# All function parameters
def test10[T](a,/,b:int,c=2,*args,**kwargs):
    pass

# Class template parameters
class CLS[T]:
    pass

# Lambdas
lambda :
lambda a: a
lambda a,b : a+b



EOF

input=$(srcml test_parameter.py --position)
output=$(echo "$input" | ./nameCollector )
expected="test1 is a function in Python file: test_parameter.py:2:5
test2 is a function in Python file: test_parameter.py:6:5
a is a parameter in Python file: test_parameter.py:6:11
test3 is a function in Python file: test_parameter.py:10:5
a is a parameter in Python file: test_parameter.py:10:11
b is a parameter in Python file: test_parameter.py:10:13
test4 is a function in Python file: test_parameter.py:14:5
a is a parameter in Python file: test_parameter.py:14:11
b is a parameter in Python file: test_parameter.py:14:13
c is a parameter in Python file: test_parameter.py:14:15
test5 is a function in Python file: test_parameter.py:18:5
a is a parameter in Python file: test_parameter.py:18:11
test6 is a function in Python file: test_parameter.py:22:5
a is a parameter in Python file: test_parameter.py:22:11
b is a parameter in Python file: test_parameter.py:22:15
c is a parameter in Python file: test_parameter.py:22:19
test7 is a function in Python file: test_parameter.py:26:5
args is a parameter in Python file: test_parameter.py:26:12
kwargs is a parameter in Python file: test_parameter.py:26:20
test8 is a function in Python file: test_parameter.py:30:5
T is a template-parameter in Python file: test_parameter.py:30:11
test9 is a function in Python file: test_parameter.py:34:5
a is a parameter in Python file: test_parameter.py:34:11
b is a parameter in Python file: test_parameter.py:34:18
c is a parameter in Python file: test_parameter.py:34:23
test10 is a function in Python file: test_parameter.py:38:5
T is a template-parameter in Python file: test_parameter.py:38:12
a is a parameter in Python file: test_parameter.py:38:15
b is a parameter in Python file: test_parameter.py:38:19
c is a parameter in Python file: test_parameter.py:38:25
args is a parameter in Python file: test_parameter.py:38:30
kwargs is a parameter in Python file: test_parameter.py:38:37
CLS is a class in Python file: test_parameter.py:42:7
T is a template-parameter in Python file: test_parameter.py:42:11
a is a parameter in Python file: test_parameter.py:47:8
a is a parameter in Python file: test_parameter.py:48:8
b is a parameter in Python file: test_parameter.py:48:10"

expected_parameters=(
  "a is a parameter in Python file: test_parameter.py:6:11"
  "a is a parameter in Python file: test_parameter.py:10:11"
  "b is a parameter in Python file: test_parameter.py:10:13"
  "a is a parameter in Python file: test_parameter.py:14:11"
  "b is a parameter in Python file: test_parameter.py:14:13"
  "c is a parameter in Python file: test_parameter.py:14:15"
  "a is a parameter in Python file: test_parameter.py:18:11"
  "a is a parameter in Python file: test_parameter.py:22:11"
  "b is a parameter in Python file: test_parameter.py:22:15"
  "c is a parameter in Python file: test_parameter.py:22:19"
  "args is a parameter in Python file: test_parameter.py:26:12"
  "kwargs is a parameter in Python file: test_parameter.py:26:20"
  "test8 is a function in Python file: test_parameter.py:30:5"
  "T is a template-parameter in Python file: test_parameter.py:30:11"
  "test9 is a function in Python file: test_parameter.py:34:5"
  "a is a parameter in Python file: test_parameter.py:34:11"
  "b is a parameter in Python file: test_parameter.py:34:18"
  "c is a parameter in Python file: test_parameter.py:34:23"
  "test10 is a function in Python file: test_parameter.py:38:5"
  "T is a template-parameter in Python file: test_parameter.py:38:12"
  "a is a parameter in Python file: test_parameter.py:38:15"
  "b is a parameter in Python file: test_parameter.py:38:19"
  "c is a parameter in Python file: test_parameter.py:38:25"
  "args is a parameter in Python file: test_parameter.py:38:30"
  "kwargs is a parameter in Python file: test_parameter.py:38:37"
  "T is a template-parameter in Python file: test_parameter.py:42:11"
)

# make sure parameters are collected correctly in both hpp and cpp files
for parameter in "${expected_parameters[@]}"; do
  if ! echo "$output" | grep -Fq "$parameter"; then
    echo "Test test_py_parameter failed!"
    echo "Expected parameter: '$parameter' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_py_parameter passed!" # all parameters collected correctly

# fail if output does not match expected, even if the parameters are collected correctly
if [[ "$output" != "$expected" ]]; then
    echo "Test test_py_parameter output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

# Repeat tests

exit 0
