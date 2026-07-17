#!/bin/bash

# test the collection of field variable names in Javascript

cat <<EOF > test_field.js
class C {
  static x = 1;
  y;
  z = 2;
  #priv = 3;
  static #st_priv = 4;

  function func() {
    class inner {
      static a = 1;
      b;
      c = 2;
      #i_priv = 3;
      static #i_st_priv = 4;
    }
  }
}

EOF

input=$(srcml test_field.js --position)
output=$(echo "$input" | ./nameCollector )
expected="C is a class in JavaScript file: test_field.js:1:7
x is a field in JavaScript file: test_field.js:2:10
y is a field in JavaScript file: test_field.js:3:3
z is a field in JavaScript file: test_field.js:4:3
#priv is a field in JavaScript file: test_field.js:5:3
#st_priv is a field in JavaScript file: test_field.js:6:10
func is a function in JavaScript file: test_field.js:8:12
inner is a class in JavaScript file: test_field.js:9:11
a is a field in JavaScript file: test_field.js:10:14
b is a field in JavaScript file: test_field.js:11:7
c is a field in JavaScript file: test_field.js:12:7
#i_priv is a field in JavaScript file: test_field.js:13:7
#i_st_priv is a field in JavaScript file: test_field.js:14:14"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_js_field failed!"
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_js_field passed!"
# Repeat tests

exit 0