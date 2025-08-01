#!/bin/bash

# test the collection of function names in C++

cat <<EOF > test_function.py
# Basic function
def foo():
    pass

# Nested
def bar():
    def bin():
        pass
    return 0

# Functions in class
class CLS:
    def __init__(self):
        pass
    def __add__(self,other):
        pass
    def calculate(self,x):
        pass

# Async function
async def async_foo():
    pass

# Decorated function
@wrapper
def inner():
    pass

# Annotated function
def max_int() -> int:
    return 2147483647 


EOF

input=$(srcml test_function.py --position)
output=$(echo "$input" | ./nameCollector )
expected="foo is a function in Python file: test_function.py:2:5
bar is a function in Python file: test_function.py:6:5
bin is a function in Python file: test_function.py:7:9
CLS is a class in Python file: test_function.py:12:7
__init__ is a function in Python file: test_function.py:13:9
self is a parameter in Python file: test_function.py:13:18
__add__ is a function in Python file: test_function.py:15:9
self is a parameter in Python file: test_function.py:15:17
other is a parameter in Python file: test_function.py:15:22
calculate is a function in Python file: test_function.py:17:9
self is a parameter in Python file: test_function.py:17:19
x is a parameter in Python file: test_function.py:17:24
async_foo is a function in Python file: test_function.py:21:11
inner is a function in Python file: test_function.py:26:5
max_int is a function in Python file: test_function.py:30:5"

expected_functions=(
  "foo is a function in Python file: test_function.py:2:5"
  "bar is a function in Python file: test_function.py:6:5"
  "bin is a function in Python file: test_function.py:7:9"
  "__init__ is a function in Python file: test_function.py:13:9"
  "__add__ is a function in Python file: test_function.py:15:9"
  "calculate is a function in Python file: test_function.py:17:9"
  "async_foo is a function in Python file: test_function.py:21:11"
  "inner is a function in Python file: test_function.py:26:5"
  "max_int is a function in Python file: test_function.py:30:5"
)

for function in "${expected_functions[@]}"; do
  if ! echo "$output" | grep -Fq "$function"; then
    echo "Test test_py_function failed!"
    echo "Expected function: '$function' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_py_function passed!" # all constructor collected correctly

# fail if output does not match expected, even if the constructors are collected correctly
if [[ "$output" != "$expected" ]]; then
    echo "Test test_py_function output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

# Repeat tests

exit 0
