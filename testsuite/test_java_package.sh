#!/bin/bash

# test the collection of package names in Java

cat <<EOF > test_namespace.java
package a;

package b.c;

package com.ecommerce.shipping;

@Deprecated
package com.example;

EOF

input=$(srcml test_namespace.java --position)
output=$(echo "$input" | ./nameCollector )
expected="a is a namespace in Java file: test_namespace.java:1:9
b is a namespace in Java file: test_namespace.java:3:9
c is a namespace in Java file: test_namespace.java:3:11
com is a namespace in Java file: test_namespace.java:5:9
ecommerce is a namespace in Java file: test_namespace.java:5:13
shipping is a namespace in Java file: test_namespace.java:5:23
com is a namespace in Java file: test_namespace.java:8:9
example is a namespace in Java file: test_namespace.java:8:13"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_java_namespace failed!" 
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_java_namespace passed!"
# Repeat tests

exit 0
