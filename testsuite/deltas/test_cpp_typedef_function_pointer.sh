#!/bin/bash

# Tests function pointer typedef rename in C++

cat <<EOF > test_typedef_function_pointer_original.cpp
typedef void (*Handler)(int);
EOF

cat <<EOF > test_typedef_function_pointer_modified.cpp
typedef void (*Callback)(int);
EOF

input=$(srcdiff test_typedef_function_pointer_original.cpp test_typedef_function_pointer_modified.cpp --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
Handler|Callback,void,typedef,test_typedef_function_pointer_original.cpp|test_typedef_function_pointer_modified.cpp,1:16,C++,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_typedef_function_pointer output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_typedef_function_pointer passed!"

exit 0
