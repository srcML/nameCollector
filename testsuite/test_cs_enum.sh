#!/bin/bash

# test the collection of struct names and struct object names
# output of struct within typedef definition includes some spacing issue and newline issue

cat <<EOF > test_enum.cs
public enum OrderStatus
{
    Pending,    // 0
    Processing, // 1
    Shipped,    // 2
    Delivered   // 3
}
EOF

input=$(srcml test_enum.cs --position)
output=$(echo "$input" | ./nameCollector )
expected="OrderStatus is a enum in C# file: test_enum.cs:1:13
Pending is a field in C# file: test_enum.cs:3:5
Processing is a field in C# file: test_enum.cs:4:5
Shipped is a field in C# file: test_enum.cs:5:5
Delivered is a field in C# file: test_enum.cs:6:5"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cs_enum output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_cs_enum passed!"
# Repeat tests

exit 0