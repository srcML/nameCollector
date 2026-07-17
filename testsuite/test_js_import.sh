#!/bin/bash

# test the collection of import alias names

cat <<EOF > test_import.js
import { calculateTax as getTax } from './utils.js';
import MyButton from './Button.js';
import { default as CoolButton } from './Button.js';
import { defineConfig } from 'vite';
import * as MathUtils from './math.js';

import { 
  originalName1 as aliasName1, 
  originalName2 as aliasName2 
} from './my-module.js';

EOF

input=$(srcml test_import.js --position)
output=$(echo "$input" | ./nameCollector)
expected="getTax is a global in JavaScript file: test_import.js:1:26
CoolButton is a global in JavaScript file: test_import.js:3:21
MathUtils is a namespace in JavaScript file: test_import.js:5:13
aliasName1 is a global in JavaScript file: test_import.js:8:20
aliasName2 is a global in JavaScript file: test_import.js:9:20"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_js_import failed!" 
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_js_import passed!"
# Repeat tests

exit 0
