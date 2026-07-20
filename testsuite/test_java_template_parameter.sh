#!/bin/bash

cat <<EOF > test_template_parameter.java 
class Box<A> { }
class Pair<B, C> { }
class Node<D extends Comparable<D>> { }
interface Repository<E> { }
interface Map<F, G> { }
enum Result<H> { }
class Example {
    <I> I identity() {}
    <J, K> Map<J, K> createMap() {}
    <L> Example() {}
}
// TODO: Add records when srcML supports them
EOF

input=$(srcml test_template_parameter.java  --position)
output=$(echo "$input" | ./nameCollector )
expected="Box is a class in Java file: test_template_parameter.java:1:7
A is a template-parameter in Java file: test_template_parameter.java:1:11
Pair is a class in Java file: test_template_parameter.java:2:7
B is a template-parameter in Java file: test_template_parameter.java:2:12
C is a template-parameter in Java file: test_template_parameter.java:2:15
Node is a class in Java file: test_template_parameter.java:3:7
D is a template-parameter in Java file: test_template_parameter.java:3:12
Repository is a interface in Java file: test_template_parameter.java:4:11
E is a template-parameter in Java file: test_template_parameter.java:4:22
Map is a interface in Java file: test_template_parameter.java:5:11
F is a template-parameter in Java file: test_template_parameter.java:5:15
G is a template-parameter in Java file: test_template_parameter.java:5:18
Result is a enum in Java file: test_template_parameter.java:6:6
H is a template-parameter in Java file: test_template_parameter.java:6:13
Example is a class in Java file: test_template_parameter.java:7:7
I is a template-parameter in Java file: test_template_parameter.java:8:6
identity is a <I> I function in Java file: test_template_parameter.java:8:11
J is a template-parameter in Java file: test_template_parameter.java:9:6
K is a template-parameter in Java file: test_template_parameter.java:9:9
createMap is a <J, K> Map<J, K> function in Java file: test_template_parameter.java:9:22
L is a template-parameter in Java file: test_template_parameter.java:10:6
Example is a constructor in Java file: test_template_parameter.java:10:9"



if [[ "$output" != "$expected" ]]; then
    echo "Test test_java_template_parameter output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_java_template_parameter passed!"
# Repeat tests

exit 0