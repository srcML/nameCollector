#!/bin/bash

# test the collection of interface names in Java

cat <<EOF > test_interface.java
interface A {}
public interface B {}
abstract interface C {}
strictfp interface D {}
interface E extends A, B {}
class Outer {
    interface Inner {}
    void f() {
        interface Local {}
    }
}
interface Unnested {
    interface Nested {}
}
EOF

input=$(srcml test_interface.java --position)
output=$(echo "$input" | ./nameCollector )
expected="A is a interface in Java file: test_interface.java:1:11
B is a interface in Java file: test_interface.java:2:18
C is a interface in Java file: test_interface.java:3:20
D is a interface in Java file: test_interface.java:4:20
E is a interface in Java file: test_interface.java:5:11
Outer is a class in Java file: test_interface.java:6:7
Inner is a interface in Java file: test_interface.java:7:15
f is a void function in Java file: test_interface.java:8:10
Local is a interface in Java file: test_interface.java:9:19
Unnested is a interface in Java file: test_interface.java:12:11
Nested is a interface in Java file: test_interface.java:13:15"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_java_interface failed!" 
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_java_interface passed!"
# Repeat tests

exit 0
