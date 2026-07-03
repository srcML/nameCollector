#!/bin/bash

# Edge case: tests generic method rename with type parameter

cat <<EOF > test_function_generic_return_original.java
public class Converter {
<T> T transform(T input) { return input; }
}
EOF

cat <<EOF > test_function_generic_return_modified.java
public class Converter {
<T> T convert(T input) { return input; }
}
EOF

input=$(srcdiff test_function_generic_return_original.java test_function_generic_return_modified.java --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
Converter,,class,test_function_generic_return_original.java|test_function_generic_return_modified.java,1:14,Java,
transform|convert,,function,test_function_generic_return_original.java|test_function_generic_return_modified.java,2:7,Java,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_function_generic_return output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_function_generic_return passed!"

exit 0
