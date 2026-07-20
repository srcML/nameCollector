#!/bin/bash

# Edge case: tests overloaded methods with same name but different signatures

cat <<EOF > test_function_overloaded_original.java
public class Calc {
int add(int a) { return a; }
int add(int a, int b) { return a + b; }
}
EOF

cat <<EOF > test_function_overloaded_modified.java
public class Calc {
int sum(int a) { return a; }
int sum(int a, int b) { return a + b; }
}
EOF

input=$(srcdiff test_function_overloaded_original.java test_function_overloaded_modified.java --position)
output=$(echo "$input" | ./nameCollector --csv)

expected="Name,Type,Category,File,Position,Language,Stereotype
Calc,,class,test_function_overloaded_original.java|test_function_overloaded_modified.java,1:14,Java,
add|sum,int,function,test_function_overloaded_original.java|test_function_overloaded_modified.java,2:5,Java,
a,int,parameter,test_function_overloaded_original.java|test_function_overloaded_modified.java,2:13,Java,
add|sum,int,function,test_function_overloaded_original.java|test_function_overloaded_modified.java,3:5,Java,
a,int,parameter,test_function_overloaded_original.java|test_function_overloaded_modified.java,3:13,Java,
b,int,parameter,test_function_overloaded_original.java|test_function_overloaded_modified.java,3:20,Java,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_function_overloaded output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi

echo "Test test_function_overloaded passed!"

exit 0
