#!/bin/bash

# Tests renaming multiple local variables in one method

cat <<EOF > test_local_multiple_vars_original.java
public class App {
void run() {
int x = 1;
int y = 2;
}
}
EOF

cat <<EOF > test_local_multiple_vars_modified.java
public class App {
void run() {
int alpha = 1;
int beta = 2;
}
}
EOF

input=$(srcdiff test_local_multiple_vars_original.java test_local_multiple_vars_modified.java --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
App,,class,test_local_multiple_vars_original.java|test_local_multiple_vars_modified.java,1:14,Java,
run,void,function,test_local_multiple_vars_original.java|test_local_multiple_vars_modified.java,2:6,Java,
x|alpha,int,local,test_local_multiple_vars_original.java|test_local_multiple_vars_modified.java,3:5,Java,
y|beta,int,local,test_local_multiple_vars_original.java|test_local_multiple_vars_modified.java,4:5,Java,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_local_multiple_vars output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_local_multiple_vars passed!"

exit 0
