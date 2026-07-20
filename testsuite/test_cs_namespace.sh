#!/bin/bash

# test the collection of namespace names in C#

cat <<EOF > test_namespace.cs
namespace FileSpace;

namespace MyApp.Services;

namespace EnterpriseApp.Services.Payments;

namespace MyNamespace {}

namespace Outer
{
    namespace Inner {} 
}

EOF

input=$(srcml test_namespace.cs --position)
output=$(echo "$input" | ./nameCollector )
expected="FileSpace is a namespace in C# file: test_namespace.cs:1:11
MyApp is a namespace in C# file: test_namespace.cs:3:11
Services is a namespace in C# file: test_namespace.cs:3:17
EnterpriseApp is a namespace in C# file: test_namespace.cs:5:11
Services is a namespace in C# file: test_namespace.cs:5:25
Payments is a namespace in C# file: test_namespace.cs:5:34
MyNamespace is a namespace in C# file: test_namespace.cs:7:11
Outer is a namespace in C# file: test_namespace.cs:9:11
Inner is a namespace in C# file: test_namespace.cs:11:15"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cs_namespace failed!" 
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_cs_namespace passed!"
# Repeat tests

exit 0
