#!/bin/bash

# test the collection of class and class field names

cat <<EOF > test_class.js
class A {}
const b = class B {};
class C extends A {}

EOF

input=$(srcml test_class.js --position)
output=$(echo "$input" | ./nameCollector )
expected="A is a class in JavaScript file: test_class.js:1:7
b is a global in JavaScript file: test_class.js:2:7
B is a class in JavaScript file: test_class.js:2:17
C is a class in JavaScript file: test_class.js:3:7"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_js_class failed!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
echo "Test test_js_class passed!"
# Repeat tests

exit 0
