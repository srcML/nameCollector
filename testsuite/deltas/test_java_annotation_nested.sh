#!/bin/bash

# Tests nested annotation type rename inside a class

cat <<EOF > test_annotation_nested_original.java
class Outer {
@interface Inner {
}
}
EOF

cat <<EOF > test_annotation_nested_modified.java
class Outer {
@interface Nested {
}
}
EOF

input=$(srcdiff test_annotation_nested_original.java test_annotation_nested_modified.java --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
Outer,,class,test_annotation_nested_original.java|test_annotation_nested_modified.java,1:7,Java,
Inner|Nested,,annotation,test_annotation_nested_original.java|test_annotation_nested_modified.java,2:12,Java,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_annotation_nested output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_annotation_nested passed!"

exit 0
