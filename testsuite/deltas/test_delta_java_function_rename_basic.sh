#!/bin/bash

# Tests basic method rename

cat <<EOF > test_function_rename_basic_original.java
public class Util {
void process() {}
}
EOF

cat <<EOF > test_function_rename_basic_modified.java
public class Util {
void execute() {}
}
EOF

input=$(srcdiff test_function_rename_basic_original.java test_function_rename_basic_modified.java --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
Util,,class,test_function_rename_basic_original.java|test_function_rename_basic_modified.java,1:14,Java,
process|execute,void,function,test_function_rename_basic_original.java|test_function_rename_basic_modified.java,2:6,Java,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_function_rename_basic output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_function_rename_basic passed!"

exit 0
