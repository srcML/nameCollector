#!/bin/bash

# Tests method rename with throws clause

cat <<EOF > test_function_throws_original.java
public class Sender {
void send() throws Exception {}
}
EOF

cat <<EOF > test_function_throws_modified.java
public class Sender {
void dispatch() throws Exception {}
}
EOF

input=$(srcdiff test_function_throws_original.java test_function_throws_modified.java --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
Sender,,class,test_function_throws_original.java|test_function_throws_modified.java,1:14,Java,
send|dispatch,void,function,test_function_throws_original.java|test_function_throws_modified.java,2:6,Java,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_function_throws output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_function_throws passed!"

exit 0
