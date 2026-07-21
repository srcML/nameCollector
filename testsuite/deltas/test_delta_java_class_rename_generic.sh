#!/bin/bash

# Tests class name rename with generic type parameter

cat <<EOF > test_class_rename_generic_original.java
public class Box<T> {
}
EOF

cat <<EOF > test_class_rename_generic_modified.java
public class Container<T> {
}
EOF

input=$(srcdiff test_class_rename_generic_original.java test_class_rename_generic_modified.java --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
Box|Container,,class,test_class_rename_generic_original.java|test_class_rename_generic_modified.java,1:14,Java,
T,,generic-parameter,test_class_rename_generic_original.java|test_class_rename_generic_modified.java,1:18|1:24,Java,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_class_rename_generic output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_class_rename_generic passed!"

exit 0
