#!/bin/bash

# Tests basic local variable rename

cat <<EOF > test_local_rename_basic_original.java
public class App {
void run() {
int count = 0;
}
}
EOF

cat <<EOF > test_local_rename_basic_modified.java
public class App {
void run() {
int totalCount = 0;
}
}
EOF

input=$(srcdiff test_local_rename_basic_original.java test_local_rename_basic_modified.java --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
App,,class,test_local_rename_basic_original.java|test_local_rename_basic_modified.java,1:14,Java,
run,void,function,test_local_rename_basic_original.java|test_local_rename_basic_modified.java,2:6,Java,
count|totalCount,int,local,test_local_rename_basic_original.java|test_local_rename_basic_modified.java,3:5,Java,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_local_rename_basic output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_local_rename_basic passed!"

exit 0
