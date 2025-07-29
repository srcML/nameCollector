#!/bin/bash

# test the collection of namespace names
# NOTE 7/28/25: namespace aliases are collected, this is related to issue #21, the test will fail with message:
# "Test test_cpp_namespace failed!" until the issue is fixed

cat <<EOF > test_namespace.cpp
namespace SimpleNSP{
    void simpleMemberFunction();
}
inline namespace InlineNamespace{ //empty };

namespace OuterNamespace{
    class OuterMemberClass{
        // empty
    };
    
    namespace InnerNamespace{
        bool innerMember;
        namespace ThirdNestedNSP{ //empty}; 
    }
}
//with aliases
namespace nsp = SimpleNSP::abc::xyc;

EOF

input=$(srcml test_namespace.cpp --position)
output=$(echo "$input" | ./nameCollector )
expected="SimpleNSP is a namespace in C++ file: test_namespace.cpp:1:11
simpleMemberFunction is a void function in C++ file: test_namespace.cpp:2:10
InlineNamespace is a namespace in C++ file: test_namespace.cpp:4:18
OuterNamespace is a namespace in C++ file: test_namespace.cpp:6:11
OuterMemberClass is a class in C++ file: test_namespace.cpp:7:11
InnerNamespace is a namespace in C++ file: test_namespace.cpp:11:15
innerMember is a bool global in C++ file: test_namespace.cpp:12:14
ThirdNestedNSP is a namespace in C++ file: test_namespace.cpp:13:19
nsp is a namespace in C++ file: test_namespace.cpp:17:11"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_namespace failed!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
echo "Test test_cpp_namespace passed!"
# Repeat tests

exit 0