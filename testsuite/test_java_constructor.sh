#!/bin/bash

# test the collection of constructor names in Java

cat <<EOF > test_constructor.java
class A {
    A() {}
    A(int x) {}
}
abstract class B {
    B() {}
}
enum E {
    A(1), B(2);

    private final int value;

    E(int value) {
        this.value = value;
    }
}
// TODO add Records when srcML is updated to support them
EOF

input=$(srcml test_constructor.java --position)
output=$(echo "$input" | ./nameCollector)
expected="A is a class in Java file: test_constructor.java:1:7
A is a constructor in Java file: test_constructor.java:2:5
A is a constructor in Java file: test_constructor.java:3:5
x is a int parameter in Java file: test_constructor.java:3:11
B is a class in Java file: test_constructor.java:5:16
B is a constructor in Java file: test_constructor.java:6:5
E is a enum in Java file: test_constructor.java:8:6
A is a field in Java file: test_constructor.java:9:5
B is a field in Java file: test_constructor.java:9:11
value is a private final int field in Java file: test_constructor.java:11:23
E is a constructor in Java file: test_constructor.java:13:5
value is a int parameter in Java file: test_constructor.java:13:11"


# fail if output does not match expected, even if the constructors are collected correctly
if [[ "$output" != "$expected" ]]; then
    echo "Test test_java_constructor output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_java_constructor passed!"
# Repeat tests

exit 0
