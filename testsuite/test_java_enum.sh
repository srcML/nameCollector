#!/bin/bash

# test the collection of struct names and struct object names in Java
# output of struct within typedef definition includes some spacing issue and newline issue

cat <<EOF > test_enum.java
enum Empty {}
enum Color {
    RED, GREEN, BLUE,
}
enum Operation {
    ADD {
        int apply(int a, int b) { return a + b; }
    },
    SUBTRACT {
        int apply(int a, int b) { return a - b; }
    };
    abstract int apply(int a, int b);
}
enum Outer {
    X;
    enum Inner {
        A, B
    }
}
EOF

input=$(srcml test_enum.java --position)
output=$(echo "$input" | ./nameCollector )
expected="Empty is a enum in Java file: test_enum.java:1:6
Color is a enum in Java file: test_enum.java:2:6
RED is a field in Java file: test_enum.java:3:5
GREEN is a field in Java file: test_enum.java:3:10
BLUE is a field in Java file: test_enum.java:3:17
Operation is a enum in Java file: test_enum.java:5:6
ADD is a field in Java file: test_enum.java:6:5
apply is a int function in Java file: test_enum.java:7:13
a is a int parameter in Java file: test_enum.java:7:23
b is a int parameter in Java file: test_enum.java:7:30
SUBTRACT is a field in Java file: test_enum.java:9:5
apply is a int function in Java file: test_enum.java:10:13
a is a int parameter in Java file: test_enum.java:10:23
b is a int parameter in Java file: test_enum.java:10:30
apply is a abstract int function in Java file: test_enum.java:12:18
a is a int parameter in Java file: test_enum.java:12:28
b is a int parameter in Java file: test_enum.java:12:35
Outer is a enum in Java file: test_enum.java:14:6
X is a field in Java file: test_enum.java:15:5
Inner is a enum in Java file: test_enum.java:16:10
A is a field in Java file: test_enum.java:17:9
B is a field in Java file: test_enum.java:17:12"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_java_enum output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_java_enum passed!"
# Repeat tests

exit 0