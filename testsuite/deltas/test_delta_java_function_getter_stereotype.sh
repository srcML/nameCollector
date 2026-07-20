#!/bin/bash

# Tests getter method rename with stereotype inference

cat <<EOF > test_function_getter_stereotype_original.java
public class Item {
int getValue() { return 0; }
}
EOF

cat <<EOF > test_function_getter_stereotype_modified.java
public class Item {
int fetchValue() { return 0; }
}
EOF

input=$(srcdiff test_function_getter_stereotype_original.java test_function_getter_stereotype_modified.java --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
Item,,class,test_function_getter_stereotype_original.java|test_function_getter_stereotype_modified.java,1:14,Java,
getValue|fetchValue,int,function,test_function_getter_stereotype_original.java|test_function_getter_stereotype_modified.java,2:5,Java,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_function_getter_stereotype output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_function_getter_stereotype passed!"

exit 0
