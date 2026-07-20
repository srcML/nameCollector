#!/bin/bash

# Tests annotation type definition rename in Java

cat <<EOF > test_annotation_definition_original.java
@interface Mark {
}
EOF

cat <<EOF > test_annotation_definition_modified.java
@interface Tag {
}
EOF

input=$(srcdiff test_annotation_definition_original.java test_annotation_definition_modified.java --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
Mark|Tag,,annotation,test_annotation_definition_original.java|test_annotation_definition_modified.java,1:12,Java,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_annotation_definition output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_annotation_definition passed!"

exit 0
