#!/bin/bash

# test the collection of named labels, as in goto in Java

cat <<EOF > test_label.java
class Program {
    public static void main() {
        StartOver:
        while(true) {
            break StartOver;
        }
    }
}
EOF

input=$(srcml test_label.java --position)
output=$(echo "$input" | ./nameCollector )
expected="Program is a class in Java file: test_label.java:1:7
main is a public static void function in Java file: test_label.java:2:24
StartOver is a label in Java file: test_label.java:3:9"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_java_label failed!"
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_java_label passed!"
# Repeat tests

exit 0
