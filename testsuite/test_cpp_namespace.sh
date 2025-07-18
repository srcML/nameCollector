#!/bin/bash

# test the collection of namespace names

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
expected="int_vector is a vector<int> typedef in C++ file: test_namespace.cpp at 2:21
char_array is a char* typedef in C++ file: test_namespace.cpp at 3:15
functionPtr is a int function in C++ file: test_namespace.cpp at 4:15"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_namespace failed!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
echo "Test test_cpp_namespace passed!"
# Repeat tests

exit 0