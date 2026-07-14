#!/bin/bash

# test the collection of named labels in JavaScript

cat <<EOF > test_label.js
loop1: while(1) {
    loop2: while(1) {
        if (1) {
            break loop1;
        }
    }
}
outer:
console.log("!");

blockOfCode: {
    console.log('This part will be executed');
    break blockOfCode;
    console.log('this part will not be executed');
}
EOF

input=$(srcml test_label.js --position)
output=$(echo "$input" | ./nameCollector )
expected="loop1 is a label in JavaScript file: test_label.js:1:1
loop2 is a label in JavaScript file: test_label.js:2:5
outer is a label in JavaScript file: test_label.js:8:1
blockOfCode is a label in JavaScript file: test_label.js:11:1"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_js_label failed!"
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_js_label passed!"
# Repeat tests

exit 0
