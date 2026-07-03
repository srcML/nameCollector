#!/bin/bash

# Edge case: tests local variable rename with generic type declaration

cat <<EOF > test_local_generic_type_original.java
public class App {
void run() {
List<String> items = new ArrayList<>();
}
}
EOF

cat <<EOF > test_local_generic_type_modified.java
public class App {
void run() {
List<String> entries = new ArrayList<>();
}
}
EOF

input=$(srcdiff test_local_generic_type_original.java test_local_generic_type_modified.java --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
App,,class,test_local_generic_type_original.java|test_local_generic_type_modified.java,1:14,Java,
run,void,function,test_local_generic_type_original.java|test_local_generic_type_modified.java,2:6,Java,
items|entries,List<String>,local,test_local_generic_type_original.java|test_local_generic_type_modified.java,3:14,Java,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_local_generic_type output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_local_generic_type passed!"

exit 0
