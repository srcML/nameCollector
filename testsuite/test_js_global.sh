#!/bin/bash

# test the collection of global variable names in javascript

cat <<EOF > test_global.js
var x = 1;
let y = 2;
const z = 3;
{
  var a = 2;
}
{
  let b = 2;
}
const obj = { i: 1, k: 2 };
const { i, j } = obj;
EOF

input=$(srcml test_global.js --position)
output=$(echo "$input" | ./nameCollector )
expected="x is a global in JavaScript file: test_global.js:1:5
y is a global in JavaScript file: test_global.js:2:5
z is a global in JavaScript file: test_global.js:3:7
a is a global in JavaScript file: test_global.js:5:7
b is a local in JavaScript file: test_global.js:8:7
obj is a global in JavaScript file: test_global.js:10:7
i is a global in JavaScript file: test_global.js:11:9
j is a global in JavaScript file: test_global.js:11:12"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_js_global failed!"
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_js_global passed!"
# Repeat tests

exit 0
