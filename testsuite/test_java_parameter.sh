#!/bin/bash

# tests the collection of locals in Java

cat <<EOF > test_local.java
class C {
    void m(int x, String s) {
        try {} 
        catch (Exception e) {}
    }
    void n(String... args) {}
    C(int x) {}
    MathOperation multiply = (a, b) -> a * b;
    MathOperation multiply2 = (int c, int d) -> c * d;
}
EOF

input=$(srcml test_local.java --position)
output=$(echo "$input" | ./nameCollector )
expected="C is a class in Java file: test_local.java:1:7
m is a void function in Java file: test_local.java:2:10
x is a int parameter in Java file: test_local.java:2:16
s is a String parameter in Java file: test_local.java:2:26
e is a Exception parameter in Java file: test_local.java:4:26
n is a void function in Java file: test_local.java:6:10
args is a String... parameter in Java file: test_local.java:6:22
C is a constructor in Java file: test_local.java:7:5
x is a int parameter in Java file: test_local.java:7:11
multiply is a MathOperation field in Java file: test_local.java:8:19
a is a parameter in Java file: test_local.java:8:31
b is a parameter in Java file: test_local.java:8:34
multiply2 is a MathOperation field in Java file: test_local.java:9:19
c is a int parameter in Java file: test_local.java:9:36
d is a int parameter in Java file: test_local.java:9:43"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_java_local output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_java_local passed!"
# Repeat tests

exit 0