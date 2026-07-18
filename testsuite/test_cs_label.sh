#!/bin/bash

# test the collection of named labels, as in goto

cat <<EOF > test_label.cs
class Program
{
    static void Main()
    {
        StartOver:
        while(true)
        {
            goto DiagnosticsBreak;
        }
        DiagnosticsBreak: 
        Console.WriteLine("Exited nested loops smoothly.");
        goto StartOver;
    }
}

EOF

input=$(srcml test_label.cs --position)
output=$(echo "$input" | ./nameCollector )
expected="Program is a class in C# file: test_label.cs:1:7
Main is a static void function in C# file: test_label.cs:3:17
StartOver is a label in C# file: test_label.cs:5:9
DiagnosticsBreak is a label in C# file: test_label.cs:10:9"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cs_label failed!"
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_cs_label passed!"
# Repeat tests

exit 0
