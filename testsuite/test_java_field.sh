#!/bin/bash

# tests the collection of fields in Java

cat <<EOF > test_field.java
class C {
    int a;
    class Local {
        int b;
    }
    public int c;
    protected int d;
    private int e;
    static int f;
    final int g;
    int h = 10;
    List<String> names;
}
enum E {
    A, B;
    int value;
}
interface I {
    int X = 10;
}
class CLS {
    Runnable r = new Runnable() {
        int x = 5;
    };
    int y, z = 10;
}
EOF

input=$(srcml test_field.java --position)
output=$(echo "$input" | ./nameCollector )
expected="C is a class in Java file: test_field.java:1:7
a is a int field in Java file: test_field.java:2:9
Local is a class in Java file: test_field.java:3:11
b is a int field in Java file: test_field.java:4:13
c is a public int field in Java file: test_field.java:6:16
d is a protected int field in Java file: test_field.java:7:19
e is a private int field in Java file: test_field.java:8:17
f is a static int field in Java file: test_field.java:9:16
g is a final int field in Java file: test_field.java:10:15
h is a int field in Java file: test_field.java:11:9
names is a List<String> field in Java file: test_field.java:12:18
E is a enum in Java file: test_field.java:14:6
A is a field in Java file: test_field.java:15:5
B is a field in Java file: test_field.java:15:8
value is a int field in Java file: test_field.java:16:9
I is a interface in Java file: test_field.java:18:11
X is a int field in Java file: test_field.java:19:9
CLS is a class in Java file: test_field.java:21:7
r is a Runnable field in Java file: test_field.java:22:14
x is a int field in Java file: test_field.java:23:13
y is a int field in Java file: test_field.java:25:9
z is a int field in Java file: test_field.java:25:12"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_java_field output did not match expected!"
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_java_field passed!"
# Repeat tests

exit 0