#!/bin/bash

# test the collection of namespace names

cat <<EOF > test_namespace.cpp
// anonymous namespace
namespace {}

namespace SimpleNSP{
    void simpleMemberFunction();
    namespace abc{
        namespace xyc{
            // empty
        }
    }
}
inline namespace InlineNamespace{ /*empty */ };

namespace OuterNamespace{
    class OuterMemberClass{
        // empty
    };
    
    namespace InnerNamespace{
        bool innerMember;
        namespace ThirdNestedNSP{ /* empty */}; 
    }
}
//with aliases
namespace nsp = SimpleNSP::abc::xyc;

// anonymous namespace again
namespace {};

int main() {
    return 0;
}

EOF

input=$(srcml test_namespace.cpp --position)
output=$(echo "$input" | ./nameCollector )
expected="SimpleNSP is a namespace in C++ file: test_namespace.cpp:4:11
simpleMemberFunction is a void function in C++ file: test_namespace.cpp:5:10
abc is a namespace in C++ file: test_namespace.cpp:6:15
xyc is a namespace in C++ file: test_namespace.cpp:7:19
InlineNamespace is a namespace in C++ file: test_namespace.cpp:12:18
OuterNamespace is a namespace in C++ file: test_namespace.cpp:14:11
OuterMemberClass is a class in C++ file: test_namespace.cpp:15:11
InnerNamespace is a namespace in C++ file: test_namespace.cpp:19:15
innerMember is a bool global in C++ file: test_namespace.cpp:20:14
ThirdNestedNSP is a namespace in C++ file: test_namespace.cpp:21:19
nsp is a namespace in C++ file: test_namespace.cpp:25:11
main is a int function in C++ file: test_namespace.cpp:30:5"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_cpp_namespace failed!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
echo "Test test_cpp_namespace passed!"
# Repeat tests

exit 0
