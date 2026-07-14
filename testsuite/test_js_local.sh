#!/bin/bash

# test the collection of local variable names in Javascript

cat <<EOF > test_local.js
function myFunction1() {
  var carName1 = "Volvo";  // Function Scope
}

function myFunction2() {
  let carName2 = "Volvo";  // Function Scope
}

function myFunction3() {
  const carName3 = "Volvo";  // Function Scope
}

{
  let a = 2;
}

{
  const b = 2;
}

{
  var c = 2;
}

EOF

input=$(srcml test_local.js --position)
output=$(echo "$input" | ./nameCollector )
expected="myFunction1 is a function in JavaScript file: test_local.js:1:10
carName1 is a local in JavaScript file: test_local.js:2:7
myFunction2 is a function in JavaScript file: test_local.js:5:10
carName2 is a local in JavaScript file: test_local.js:6:7
myFunction3 is a function in JavaScript file: test_local.js:9:10
carName3 is a local in JavaScript file: test_local.js:10:9
a is a local in JavaScript file: test_local.js:14:7
b is a local in JavaScript file: test_local.js:18:9
c is a global in JavaScript file: test_local.js:22:7"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_js_local failed!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
echo "Test test_js_local passed!"
# Repeat tests

exit 0