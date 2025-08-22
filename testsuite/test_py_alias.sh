#!/bin/bash

# test the collection of import alias names

cat <<EOF > test_alias.py
import module as ns1
import module1 as ns2, module2 as ns3
from module import obj as val
from module import obj1 as val1, obj2 as val2

with call as ctx:
    pass

try:
    pass
except Exception as e:
    pass

match x:
    case 10 as c:
        pass

import different_module as ns1
from different_module import new_obj as val

def foo():
    import module as ns1
    from module import obj as val
    with call as ctx:
        pass

    try:
        pass
    except Exception as e:
        pass

    match x:
        case 10 as c:
            pass

    def inner():
        global ns1, val, ctx, c
        import module as ns1
        from module import obj as val
        with call as ctx:
            pass

        try:
            pass
        except Exception as e:
            pass

        match x:
            case 10 as c:
                pass
EOF

input=$(srcml test_alias.py --position)
output=$(echo "$input" | ./nameCollector)
expected="ns1 is a namespace in Python file: test_alias.py:1:18
ns2 is a namespace in Python file: test_alias.py:2:19
ns3 is a namespace in Python file: test_alias.py:2:35
val is a global in Python file: test_alias.py:3:27
val1 is a global in Python file: test_alias.py:4:28
val2 is a global in Python file: test_alias.py:4:42
ctx is a global in Python file: test_alias.py:6:14
e is a local in Python file: test_alias.py:11:21
c is a global in Python file: test_alias.py:15:16
foo is a function in Python file: test_alias.py:21:5
ns1 is a namespace in Python file: test_alias.py:22:22
val is a local in Python file: test_alias.py:23:31
ctx is a local in Python file: test_alias.py:24:18
e is a local in Python file: test_alias.py:29:25
c is a local in Python file: test_alias.py:33:20
inner is a function in Python file: test_alias.py:36:9
e is a local in Python file: test_alias.py:45:29"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_py_alias failed!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
echo "Test test_py_alias passed!"
# Repeat tests

exit 0
