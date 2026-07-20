#!/bin/bash

# Tests basic class name rename

cat <<EOF > test_class_rename_basic_original.java
public class Foo {
}
EOF

cat <<EOF > test_class_rename_basic_modified.java
public class Bar {
}
EOF

input=$(srcdiff test_class_rename_basic_original.java test_class_rename_basic_modified.java --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
Foo|Bar,,class,test_class_rename_basic_original.java|test_class_rename_basic_modified.java,1:14,Java,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_class_rename_basic output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_class_rename_basic passed!"

exit 0
