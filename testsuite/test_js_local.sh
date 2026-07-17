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

function myFunction4() {
  using name1 = new value1(), name2 = new value2(); // Function Scope
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

{
  using nameN = new valueN();
}

function outer_func() {
  class CLS {
    function inner_func() {
      let val = "text";
    }
  }
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
myFunction4 is a function in JavaScript file: test_local.js:13:10
name1 is a local in JavaScript file: test_local.js:14:9
name2 is a local in JavaScript file: test_local.js:14:31
a is a local in JavaScript file: test_local.js:18:7
b is a local in JavaScript file: test_local.js:22:9
c is a global in JavaScript file: test_local.js:26:7
nameN is a local in JavaScript file: test_local.js:30:9
outer_func is a function in JavaScript file: test_local.js:33:10
CLS is a class in JavaScript file: test_local.js:34:9
inner_func is a function in JavaScript file: test_local.js:35:14
val is a local in JavaScript file: test_local.js:36:11"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_js_local failed!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
echo "Test test_js_local passed!"
# Repeat tests

exit 0