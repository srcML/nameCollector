#!/bin/bash

input=$(srcml int.cpp)
# input=$(cat <<EOF
# <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
# <unit xmlns="http://www.srcML.org/srcML/src" revision="1.0.0" language="C++" filename="test.cpp">
# <decl_stmt><decl><type><name>int</name></type> <name>y</name></decl>;</decl_stmt>
# </unit>
# EOF
# )
output=$(echo "$input" | ../bin/nameCollector )
expected="x is a int global in C++ file: int.cpp"
if [[ "$output" != "$expected" ]]; then
    echo "Test failed!"
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi

# Repeat tests

exit 0
