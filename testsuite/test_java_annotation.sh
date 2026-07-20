#!/bin/bash

# test the collection of annotation names in Java

cat <<EOF > test_annotation.java
public @interface MyAnnotation {}
class Outer {
    public @interface A {}
    protected @interface B {}
    private @interface C {}
}
EOF

input=$(srcml test_annotation.java --position)
output=$(echo "$input" | ./nameCollector)
expected="MyAnnotation is a annotation in Java file: test_annotation.java:1:19
Outer is a class in Java file: test_annotation.java:2:7
A is a annotation in Java file: test_annotation.java:3:23
B is a annotation in Java file: test_annotation.java:4:26
C is a annotation in Java file: test_annotation.java:5:24"


# fail if output does not match expected, even if the annotations are collected correctly
if [[ "$output" != "$expected" ]]; then
    echo "Test test_java_annotation output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_java_annotation passed!"
# Repeat tests

exit 0
