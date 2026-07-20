#!/bin/bash

# Edge case: tests local variable renames in nested block scopes

cat <<EOF > test_local_nested_blocks_original.java
public class App {
void run() {
int a = 1;
{
int b = 2;
}
}
}
EOF

cat <<EOF > test_local_nested_blocks_modified.java
public class App {
void run() {
int first = 1;
{
int second = 2;
}
}
}
EOF

input=$(srcdiff test_local_nested_blocks_original.java test_local_nested_blocks_modified.java --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
App,,class,test_local_nested_blocks_original.java|test_local_nested_blocks_modified.java,1:14,Java,
run,void,function,test_local_nested_blocks_original.java|test_local_nested_blocks_modified.java,2:6,Java,
a|first,int,local,test_local_nested_blocks_original.java|test_local_nested_blocks_modified.java,3:5,Java,
b|second,int,local,test_local_nested_blocks_original.java|test_local_nested_blocks_modified.java,5:5,Java,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_local_nested_blocks output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_local_nested_blocks passed!"

exit 0
