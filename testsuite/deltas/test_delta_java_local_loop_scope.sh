#!/bin/bash

# Edge case: tests local variable rename inside a for-loop scope

cat <<EOF > test_local_loop_scope_original.java
public class App {
void run() {
for (int i = 0; i < 10; i++) {
int value = i;
}
}
}
EOF

cat <<EOF > test_local_loop_scope_modified.java
public class App {
void run() {
for (int idx = 0; idx < 10; idx++) {
int value = idx;
}
}
}
EOF

input=$(srcdiff test_local_loop_scope_original.java test_local_loop_scope_modified.java --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
App,,class,test_local_loop_scope_original.java|test_local_loop_scope_modified.java,1:14,Java,
run,void,function,test_local_loop_scope_original.java|test_local_loop_scope_modified.java,2:6,Java,
i|idx,int,local,test_local_loop_scope_original.java|test_local_loop_scope_modified.java,3:10,Java,
value,int,local,test_local_loop_scope_original.java|test_local_loop_scope_modified.java,4:5,Java,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_local_loop_scope output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_local_loop_scope passed!"

exit 0
