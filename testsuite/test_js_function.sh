#!/bin/bash

# test the collection of function names in JavaScript

cat <<EOF > test_function.js
function func1() {}
export function func2() {}
async function func3() {}
const f = function() {}
const fn = function exprFunc() {}

function* genFunc1() {}
const gen = function*() {};
const gen2 = function* genExprFunc() {};

class CLS {
    clsFunc1() {}
    static clsFunc2() {}
    get clsFunc3() {}
    set clsFunc4() {}
    *genClsFunc() {}
}

const obj = {
    objFunc1() {}
    get objFunc2() {}
    set objFunc3() {}
    *genObjFunc() {}
}

(function iifeFunc() {})();

EOF

input=$(srcml test_function.js --position)
output=$(echo "$input" | ./nameCollector )
expected="func1 is a function in JavaScript file: test_function.js:1:10
func2 is a function in JavaScript file: test_function.js:2:17
func3 is a function in JavaScript file: test_function.js:3:16
f is a global in JavaScript file: test_function.js:4:7
fn is a global in JavaScript file: test_function.js:5:7
exprFunc is a function in JavaScript file: test_function.js:5:21
genFunc1 is a function in JavaScript file: test_function.js:7:11
gen is a global in JavaScript file: test_function.js:8:7
gen2 is a global in JavaScript file: test_function.js:9:7
genExprFunc is a function in JavaScript file: test_function.js:9:24
CLS is a class in JavaScript file: test_function.js:11:7
clsFunc1 is a function in JavaScript file: test_function.js:12:5
clsFunc2 is a function in JavaScript file: test_function.js:13:12
clsFunc3 is a function in JavaScript file: test_function.js:14:9
clsFunc4 is a function in JavaScript file: test_function.js:15:9
genClsFunc is a function in JavaScript file: test_function.js:16:6
obj is a global in JavaScript file: test_function.js:19:7
objFunc1 is a function in JavaScript file: test_function.js:20:5
objFunc2 is a function in JavaScript file: test_function.js:21:9
objFunc3 is a function in JavaScript file: test_function.js:22:9
genObjFunc is a function in JavaScript file: test_function.js:23:6
iifeFunc is a function in JavaScript file: test_function.js:26:11"

expected_functions=(
  ""
  ""
)

# make sure contructors are collected correctly in both hpp and js files
for function in "${expected_functions[@]}"; do
  if ! echo "$output" | grep -Fq "$function"; then
    echo "Test test_js_function failed!"
    echo "Expected function: '$function' not found"
    echo "Got:"
    echo "$output"
    exit 1
  fi
done
echo "Test test_js_function passed!" # all constructor collected correctly

# fail if output does not match expected, even if the constructors are collected correctly
if [[ "$output" != "$expected" ]]; then
    echo "Test test_js_function output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi

# Repeat tests

exit 0