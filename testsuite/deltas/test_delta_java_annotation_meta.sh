#!/bin/bash

# Tests annotation rename with a meta-annotation above it

cat <<EOF > test_annotation_meta_original.java
@Retention(RetentionPolicy.RUNTIME)
@interface Mark {
}
EOF

cat <<EOF > test_annotation_meta_modified.java
@Retention(RetentionPolicy.RUNTIME)
@interface Tag {
}
EOF

input=$(srcdiff test_annotation_meta_original.java test_annotation_meta_modified.java --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
Retention,,annotation,test_annotation_meta_original.java|test_annotation_meta_modified.java,1:2,Java,
Mark|Tag,,annotation,test_annotation_meta_original.java|test_annotation_meta_modified.java,2:12,Java,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_annotation_meta output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_annotation_meta passed!"

exit 0
