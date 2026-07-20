#!/bin/bash

# Tests annotation rename with a default element value

cat <<EOF > test_annotation_defaults_original.java
@interface Mark {
int count() default 0;
}
EOF

cat <<EOF > test_annotation_defaults_modified.java
@interface Tag {
int count() default 0;
}
EOF

input=$(srcdiff test_annotation_defaults_original.java test_annotation_defaults_modified.java --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
Mark|Tag,,annotation,test_annotation_defaults_original.java|test_annotation_defaults_modified.java,1:12,Java,
count,int,function,test_annotation_defaults_original.java|test_annotation_defaults_modified.java,2:5,Java,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_annotation_defaults output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_annotation_defaults passed!"

exit 0
