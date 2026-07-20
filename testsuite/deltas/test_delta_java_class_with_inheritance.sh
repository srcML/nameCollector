#!/bin/bash

# Tests class rename with inheritance (extends keyword)

cat <<EOF > test_class_with_inheritance_original.java
public class Base {
}
class Child extends Base {
}
EOF

cat <<EOF > test_class_with_inheritance_modified.java
public class Parent {
}
class Child extends Parent {
}
EOF

input=$(srcdiff test_class_with_inheritance_original.java test_class_with_inheritance_modified.java --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
Base|Parent,,class,test_class_with_inheritance_original.java|test_class_with_inheritance_modified.java,1:14,Java,
Child,,class,test_class_with_inheritance_original.java|test_class_with_inheritance_modified.java,3:7,Java,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_class_with_inheritance output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_class_with_inheritance passed!"

exit 0
