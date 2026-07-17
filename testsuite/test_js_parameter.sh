#!/bin/bash

# test the collection of parameter names in JavaScript

cat <<EOF > test_parameter.js
function one(a1, b1, c1) {}
function two(a2 = 1, b2 = 2) {}
function three(a3, b3 = a3 + 1) {}
function four(...args) {}
function five(a5, ...rest) {}
function six({ a6, b6 }) {}
function seven([a7, b7]) {}
function eight({ a8: { b8 } }) {}
function nine({ a9 = 1, b9 = 2 } = {}) {}

const ten = (a10, b10 = 1, ...other) => {}
const eleven = ({ a11, b11 }) => {}
const twelve = a12 => a12 * 2

EOF

input=$(srcml test_parameter.js --position)
output=$(echo "$input" | ./nameCollector )
expected="one is a function in JavaScript file: test_parameter.js:1:10
a1 is a parameter in JavaScript file: test_parameter.js:1:14
b1 is a parameter in JavaScript file: test_parameter.js:1:18
c1 is a parameter in JavaScript file: test_parameter.js:1:22
two is a function in JavaScript file: test_parameter.js:2:10
a2 is a parameter in JavaScript file: test_parameter.js:2:14
b2 is a parameter in JavaScript file: test_parameter.js:2:22
three is a function in JavaScript file: test_parameter.js:3:10
a3 is a parameter in JavaScript file: test_parameter.js:3:16
b3 is a parameter in JavaScript file: test_parameter.js:3:20
four is a function in JavaScript file: test_parameter.js:4:10
args is a parameter in JavaScript file: test_parameter.js:4:18
five is a function in JavaScript file: test_parameter.js:5:10
a5 is a parameter in JavaScript file: test_parameter.js:5:15
rest is a parameter in JavaScript file: test_parameter.js:5:22
six is a function in JavaScript file: test_parameter.js:6:10
a6 is a parameter in JavaScript file: test_parameter.js:6:16
b6 is a parameter in JavaScript file: test_parameter.js:6:20
seven is a function in JavaScript file: test_parameter.js:7:10
a7 is a parameter in JavaScript file: test_parameter.js:7:17
b7 is a parameter in JavaScript file: test_parameter.js:7:21
eight is a function in JavaScript file: test_parameter.js:8:10
b8 is a parameter in JavaScript file: test_parameter.js:8:24
nine is a function in JavaScript file: test_parameter.js:9:10
a9 is a parameter in JavaScript file: test_parameter.js:9:17
b9 is a parameter in JavaScript file: test_parameter.js:9:25
ten is a global in JavaScript file: test_parameter.js:11:1
a10 is a parameter in JavaScript file: test_parameter.js:11:14
b10 is a parameter in JavaScript file: test_parameter.js:11:19
other is a parameter in JavaScript file: test_parameter.js:11:31
eleven is a global in JavaScript file: test_parameter.js:12:1
a11 is a parameter in JavaScript file: test_parameter.js:12:19
b11 is a parameter in JavaScript file: test_parameter.js:12:24
twelve is a global in JavaScript file: test_parameter.js:13:1
a12 is a parameter in JavaScript file: test_parameter.js:13:16"

expected_parameters=(
  "a1 is a parameter in JavaScript file: test_parameter.js:1:14"
  "b1 is a parameter in JavaScript file: test_parameter.js:1:18"
  "c1 is a parameter in JavaScript file: test_parameter.js:1:22"
  "a2 is a parameter in JavaScript file: test_parameter.js:2:14"
  "b2 is a parameter in JavaScript file: test_parameter.js:2:22"
  "a3 is a parameter in JavaScript file: test_parameter.js:3:16"
  "b3 is a parameter in JavaScript file: test_parameter.js:3:20"
  "args is a parameter in JavaScript file: test_parameter.js:4:18"
  "a5 is a parameter in JavaScript file: test_parameter.js:5:15"
  "rest is a parameter in JavaScript file: test_parameter.js:5:22"
  "a6 is a parameter in JavaScript file: test_parameter.js:6:16"
  "b6 is a parameter in JavaScript file: test_parameter.js:6:20"
  "a7 is a parameter in JavaScript file: test_parameter.js:7:17"
  "b7 is a parameter in JavaScript file: test_parameter.js:7:21"
  "b8 is a parameter in JavaScript file: test_parameter.js:8:24"
  "a9 is a parameter in JavaScript file: test_parameter.js:9:17"
  "b9 is a parameter in JavaScript file: test_parameter.js:9:25"
  "a10 is a parameter in JavaScript file: test_parameter.js:11:14"
  "b10 is a parameter in JavaScript file: test_parameter.js:11:19"
  "other is a parameter in JavaScript file: test_parameter.js:11:31"
  "a11 is a parameter in JavaScript file: test_parameter.js:12:19"
  "b11 is a parameter in JavaScript file: test_parameter.js:12:24"
  "a12 is a parameter in JavaScript file: test_parameter.js:13:16"

)

for parameter in "${expected_parameters[@]}"; do
  if ! echo "$output" | grep -Fq "$parameter"; then
    echo "Test test_js_parameter failed!"
    echo "Expected parameter: '$parameter' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_js_parameter passed!" # all parameters collected correctly

# fail if output does not match expected, even if the parameters are collected correctly
if [[ "$output" != "$expected" ]]; then
    echo "Test test_js_parameter output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

# Repeat tests

exit 0