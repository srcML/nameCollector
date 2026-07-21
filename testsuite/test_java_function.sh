#!/bin/bash

# test the collection of function names in Java

cat <<EOF > test_function.java
public class Foo {
    void log() {}
    public static int add() {}
    public static final int compute() {}
    <T> T identity() {}
    public <U> U foo() {}
    <V extends Number> double doubleValue() {}
    abstract int computeAbstractly();
    default int computeDefaultly() {}
    synchronized void increment() {}
    native void callNative();
    strictfp double divide() {}
    @Override
    public String toString() {}
    public Foo() {}
}
public @interface MyAnnotation {
    int value() default 42;
    String name() default "defaultName";
}
EOF

input=$(srcml test_function.java --position)
output=$(echo "$input" | ./nameCollector)
expected="Foo is a class in Java file: test_function.java:1:14
log is a void function in Java file: test_function.java:2:10
add is a public static int function in Java file: test_function.java:3:23
compute is a public static final int function in Java file: test_function.java:4:29
T is a generic-parameter in Java file: test_function.java:5:6
identity is a <T> T function in Java file: test_function.java:5:11
U is a generic-parameter in Java file: test_function.java:6:13
foo is a public <U> U function in Java file: test_function.java:6:18
V is a generic-parameter in Java file: test_function.java:7:6
doubleValue is a <V extends Number> double function in Java file: test_function.java:7:31
computeAbstractly is a abstract int function in Java file: test_function.java:8:18
computeDefaultly is a default int function in Java file: test_function.java:9:17
increment is a synchronized void function in Java file: test_function.java:10:23
callNative is a native void function in Java file: test_function.java:11:17
divide is a strictfp double function in Java file: test_function.java:12:21
toString is a public String function in Java file: test_function.java:14:19
Foo is a constructor in Java file: test_function.java:15:12
MyAnnotation is a annotation in Java file: test_function.java:17:19
value is a int function in Java file: test_function.java:18:9
name is a String function in Java file: test_function.java:19:12"


# fail if output does not match expected, even if the constructors are collected correctly
if [[ "$output" != "$expected" ]]; then
    echo "Test test_java_function output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_java_function passed!"
# Repeat tests

exit 0
