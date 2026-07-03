#!/bin/bash

# Tests annotation rename with multiple element methods

cat <<EOF > test_annotation_multiple_elements_original.java
@interface Config {
String name();
int version();
}
EOF

cat <<EOF > test_annotation_multiple_elements_modified.java
@interface Settings {
String name();
int version();
}
EOF

input=$(srcdiff test_annotation_multiple_elements_original.java test_annotation_multiple_elements_modified.java --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
Config|Settings,,annotation,test_annotation_multiple_elements_original.java|test_annotation_multiple_elements_modified.java,1:12,Java,
name,String,function,test_annotation_multiple_elements_original.java|test_annotation_multiple_elements_modified.java,2:8,Java,
version,int,function,test_annotation_multiple_elements_original.java|test_annotation_multiple_elements_modified.java,3:5,Java,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_annotation_multiple_elements output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_annotation_multiple_elements passed!"

exit 0
