#!/bin/bash

# test the collection of class names, fields, methods in Java

cat <<EOF > test_class.java
class MyClass {}
public abstract class MyAbstractClass {}
class MyExtendedClass extends BaseClass {}
class MyImplementedClass implements InterfaceA, InterfaceB {}
class MyExtendedImplementedClass extends BaseClass implements A, B {}
class Outer {
    static class Inner {}
}
class Global {
    void method() {
        class Local {}
    }
}
final class Immutable {}
EOF

input=$(srcml test_class.java --position)
output=$(echo "$input" | ./nameCollector )
expected="MyClass is a class in Java file: test_class.java:1:7
MyAbstractClass is a class in Java file: test_class.java:2:23
MyExtendedClass is a class in Java file: test_class.java:3:7
MyImplementedClass is a class in Java file: test_class.java:4:7
MyExtendedImplementedClass is a class in Java file: test_class.java:5:7
Outer is a class in Java file: test_class.java:6:7
Inner is a class in Java file: test_class.java:7:18
Global is a class in Java file: test_class.java:9:7
method is a void function in Java file: test_class.java:10:10
Local is a class in Java file: test_class.java:11:15
Immutable is a class in Java file: test_class.java:14:13"


if [[ "$output" != "$expected" ]]; then
    echo "Test test_java_class output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_java_class passed!" # all class collected correctly

# Repeat tests

exit 0