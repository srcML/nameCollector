#!/bin/bash

input=$(srcml test_global.cpp)
# input=$(cat <<EOF
# <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
# <unit xmlns="http://www.srcML.org/srcML/src" revision="1.0.0" language="C++" filename="test.cpp">
# <decl_stmt><decl><type><name>int</name></type> <name>y</name></decl>;</decl_stmt>
# </unit>
# EOF
# )
output=$(echo "$input" | ../bin/nameCollector )
expected="global_int is a int global in C++ file: test_global.cpp
global_bool is a bool global in C++ file: test_global.cpp
global_float is a float global in C++ file: test_global.cpp
global_char is a char global in C++ file: test_global.cpp"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_global failed!"
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi

# Repeat tests

exit 0
