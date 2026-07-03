#!/bin/bash

# Tests annotation rename with an element method

cat <<EOF > test_annotation_with_elements_original.java
@interface Mark {
String value();
}
EOF

cat <<EOF > test_annotation_with_elements_modified.java
@interface Tag {
String value();
}
EOF

input=$(srcdiff test_annotation_with_elements_original.java test_annotation_with_elements_modified.java --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
Mark|Tag,,annotation,test_annotation_with_elements_original.java|test_annotation_with_elements_modified.java,1:12,Java,
value,String,function,test_annotation_with_elements_original.java|test_annotation_with_elements_modified.java,2:8,Java,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_annotation_with_elements output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_annotation_with_elements passed!"

exit 0
