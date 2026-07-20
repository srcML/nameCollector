#!/bin/bash

# tests the collection of locals in Java

cat <<EOF > test_local.java
class C {
    void m() {
        int x;
        int y = 10;
        int a, b = 2;
        final int c = 10;
    }
    static class Inner {
        void innerFunc() {
            int d;
        }
    }
    LambdaObject l = () -> {
        int rtn = 10;
        return rtn;
    };
}
EOF

input=$(srcml test_local.java --position)
output=$(echo "$input" | ./nameCollector )
expected="C is a class in Java file: test_local.java:1:7
m is a void function in Java file: test_local.java:2:10
x is a int local in Java file: test_local.java:3:13
y is a int local in Java file: test_local.java:4:13
a is a int local in Java file: test_local.java:5:13
b is a int local in Java file: test_local.java:5:16
c is a final int local in Java file: test_local.java:6:19
Inner is a class in Java file: test_local.java:8:18
innerFunc is a void function in Java file: test_local.java:9:14
d is a int local in Java file: test_local.java:10:17
l is a LambdaObject field in Java file: test_local.java:13:18
rtn is a int field in Java file: test_local.java:14:13"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_java_local output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_java_local passed!"
# Repeat tests

exit 0