#!/bin/bash

# Edge case: tests renaming of multiple top-level classes in one file

cat <<EOF > test_class_multiple_classes_original.java
public class Alpha {
}
class Beta {
}
EOF

cat <<EOF > test_class_multiple_classes_modified.java
public class First {
}
class Second {
}
EOF

input=$(srcdiff test_class_multiple_classes_original.java test_class_multiple_classes_modified.java --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
Alpha|First,,class,test_class_multiple_classes_original.java|test_class_multiple_classes_modified.java,1:14,Java,
Beta|Second,,class,test_class_multiple_classes_original.java|test_class_multiple_classes_modified.java,3:7,Java,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_class_multiple_classes output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_class_multiple_classes passed!"

exit 0
