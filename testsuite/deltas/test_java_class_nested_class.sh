#!/bin/bash

# Edge case: tests renaming of a nested inner class

cat <<EOF > test_class_nested_class_original.java
public class Container {
class Inner {
}
}
EOF

cat <<EOF > test_class_nested_class_modified.java
public class Container {
class Nested {
}
}
EOF

input=$(srcdiff test_class_nested_class_original.java test_class_nested_class_modified.java --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
Container,,class,test_class_nested_class_original.java|test_class_nested_class_modified.java,1:14,Java,
Inner|Nested,,class,test_class_nested_class_original.java|test_class_nested_class_modified.java,2:7,Java,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_class_nested_class output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_class_nested_class passed!"

exit 0
