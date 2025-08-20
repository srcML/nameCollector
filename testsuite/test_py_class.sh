#!/bin/bash

# test the collection of class and class field names

cat <<EOF > test_class.py
class Nothing:
    pass

class BoolEnum:
    TRUE = True
    FALSE = False

class Misc:
    import module as md
    from md import obj as val
    for i in range(10): pass

class Pet:
    def __init__(self,name):
        self.name = name

    def add_last_name(self,last_name):
        self.name = self.name + " " + last_name

    def register_owner(self,owner):
        self.owner = owner

    def multiple_fields(self):
        self.x, self.y = 1, 2

self = Pet()
self.x = 10
EOF

input=$(srcml test_class.py --position)
output=$(echo "$input" | ./nameCollector )
expected="Nothing is a class in Python file: test_class.py:1:7
BoolEnum is a class in Python file: test_class.py:4:7
TRUE is a field in Python file: test_class.py:5:5
FALSE is a field in Python file: test_class.py:6:5
Misc is a class in Python file: test_class.py:8:7
md is a namespace in Python file: test_class.py:9:22
val is a field in Python file: test_class.py:10:27
i is a field in Python file: test_class.py:11:9
Pet is a class in Python file: test_class.py:13:7
__init__ is a function in Python file: test_class.py:14:9
self is a parameter in Python file: test_class.py:14:18
name is a parameter in Python file: test_class.py:14:23
name is a field in Python file: test_class.py:15:14
add_last_name is a function in Python file: test_class.py:17:9
self is a parameter in Python file: test_class.py:17:23
last_name is a parameter in Python file: test_class.py:17:28
register_owner is a function in Python file: test_class.py:20:9
self is a parameter in Python file: test_class.py:20:24
owner is a parameter in Python file: test_class.py:20:29
owner is a field in Python file: test_class.py:21:14
multiple_fields is a function in Python file: test_class.py:23:9
self is a parameter in Python file: test_class.py:23:25
x is a field in Python file: test_class.py:24:14
y is a field in Python file: test_class.py:24:22
self is a global in Python file: test_class.py:26:1"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_py_class failed!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
echo "Test test_py_class passed!"
# Repeat tests

exit 0
