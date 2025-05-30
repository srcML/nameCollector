#!/bin/bash

#####################################################################
output=$(cat set.xml | ../bin/nameCollector )
expected=$(cat <<EOF
Set is a constructor in C++ file: test_set.cpp
i is a int local in C++ file: test_set.cpp
Set is a constructor in C++ file: test_set.cpp
x is a int parameter in C++ file: test_set.cpp
cardinality is a unsigned int function in C++ file: test_set.cpp
card is a unsigned int local in C++ file: test_set.cpp
i is a size_t local in C++ file: test_set.cpp
operator+ is a Set function in C++ file: test_set.cpp
rhs is a const Set& parameter in C++ file: test_set.cpp
result is a Set local in C++ file: test_set.cpp
i is a size_t local in C++ file: test_set.cpp
operator* is a Set function in C++ file: test_set.cpp
rhs is a const Set& parameter in C++ file: test_set.cpp
result is a Set local in C++ file: test_set.cpp
i is a size_t local in C++ file: test_set.cpp
operator- is a Set function in C++ file: test_set.cpp
rhs is a const Set& parameter in C++ file: test_set.cpp
result is a Set local in C++ file: test_set.cpp
i is a size_t local in C++ file: test_set.cpp
operator~ is a Set function in C++ file: test_set.cpp
result is a Set local in C++ file: test_set.cpp
i is a size_t local in C++ file: test_set.cpp
operator== is a bool function in C++ file: test_set.cpp
rhs is a const Set& parameter in C++ file: test_set.cpp
i is a size_t local in C++ file: test_set.cpp
operator<= is a bool function in C++ file: test_set.cpp
rhs is a const Set& parameter in C++ file: test_set.cpp
i is a size_t local in C++ file: test_set.cpp
operator<< is a std::ostream& function in C++ file: test_set.cpp
out is a std::ostream& parameter in C++ file: test_set.cpp
rhs is a const Set& parameter in C++ file: test_set.cpp
i is a size_t local in C++ file: test_set.cpp
operator!= is a bool function in C++ file: test_set.cpp
lhs is a const Set& parameter in C++ file: test_set.cpp
rhs is a const Set& parameter in C++ file: test_set.cpp
operator< is a bool function in C++ file: test_set.cpp
lhs is a const Set& parameter in C++ file: test_set.cpp
rhs is a const Set& parameter in C++ file: test_set.cpp
operator>= is a bool function in C++ file: test_set.cpp
lhs is a const Set& parameter in C++ file: test_set.cpp
rhs is a const Set& parameter in C++ file: test_set.cpp
operator> is a bool function in C++ file: test_set.cpp
lhs is a const Set& parameter in C++ file: test_set.cpp
rhs is a const Set& parameter in C++ file: test_set.cpp
NAMECOLLECTOR_SET_HPP_ is a macro in C++ file: test_set.hpp
COLLECTION_SIZE is a const unsigned int global in C++ file: test_set.hpp
Set is a class in C++ file: test_set.hpp
Set is a constructor in C++ file: test_set.hpp
Set is a constructor in C++ file: test_set.hpp
cardinality is a unsigned int function in C++ file: test_set.hpp
operator[] is a bool function in C++ file: test_set.hpp
operator+ is a Set function in C++ file: test_set.hpp
operator* is a Set function in C++ file: test_set.hpp
operator- is a Set function in C++ file: test_set.hpp
operator~ is a Set function in C++ file: test_set.hpp
operator== is a bool function in C++ file: test_set.hpp
operator<= is a bool function in C++ file: test_set.hpp
operator<< is a std::ostream& function in C++ file: test_set.hpp
member is a bool field in C++ file: test_set.hpp
operator!= is a bool function in C++ file: test_set.hpp
operator< is a bool function in C++ file: test_set.hpp
operator>= is a bool function in C++ file: test_set.hpp
operator> is a bool function in C++ file: test_set.hpp
main is a int function in C++ file: test_set_main.cpp
x is a Set local in C++ file: test_set_main.cpp
y is a Set local in C++ file: test_set_main.cpp
z is a Set local in C++ file: test_set_main.cpp
a is a Set local in C++ file: test_set_main.cpp
EOF
)
if [[ "$output" != "$expected" ]]; then
    echo "Test set failed!"
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
else 
    echo "Test set passed"
fi


#####################################################################
output=$(cat set_pos.xml | ../bin/nameCollector )
expected=$(cat <<EOF
Set is a constructor in C++ file: test_set.cpp at 4:6
i is a int local in C++ file: test_set.cpp at 5:14
Set is a constructor in C++ file: test_set.cpp at 10:6
x is a int parameter in C++ file: test_set.cpp at 10:14
cardinality is a unsigned int function in C++ file: test_set.cpp at 14:19
card is a unsigned int local in C++ file: test_set.cpp at 15:18
i is a size_t local in C++ file: test_set.cpp at 16:16
operator+ is a Set function in C++ file: test_set.cpp at 24:10
rhs is a const Set& parameter in C++ file: test_set.cpp at 24:31
result is a Set local in C++ file: test_set.cpp at 25:9
i is a size_t local in C++ file: test_set.cpp at 26:16
operator* is a Set function in C++ file: test_set.cpp at 32:10
rhs is a const Set& parameter in C++ file: test_set.cpp at 32:31
result is a Set local in C++ file: test_set.cpp at 33:9
i is a size_t local in C++ file: test_set.cpp at 34:16
operator- is a Set function in C++ file: test_set.cpp at 40:10
rhs is a const Set& parameter in C++ file: test_set.cpp at 40:31
result is a Set local in C++ file: test_set.cpp at 41:9
i is a size_t local in C++ file: test_set.cpp at 42:16
operator~ is a Set function in C++ file: test_set.cpp at 48:10
result is a Set local in C++ file: test_set.cpp at 49:9
i is a size_t local in C++ file: test_set.cpp at 50:16
operator== is a bool function in C++ file: test_set.cpp at 56:11
rhs is a const Set& parameter in C++ file: test_set.cpp at 56:33
i is a size_t local in C++ file: test_set.cpp at 57:16
operator<= is a bool function in C++ file: test_set.cpp at 65:11
rhs is a const Set& parameter in C++ file: test_set.cpp at 65:33
i is a size_t local in C++ file: test_set.cpp at 66:16
operator<< is a std::ostream& function in C++ file: test_set.cpp at 74:15
out is a std::ostream& parameter in C++ file: test_set.cpp at 74:40
rhs is a const Set& parameter in C++ file: test_set.cpp at 74:56
i is a size_t local in C++ file: test_set.cpp at 76:16
operator!= is a bool function in C++ file: test_set.cpp at 85:6
lhs is a const Set& parameter in C++ file: test_set.cpp at 85:28
rhs is a const Set& parameter in C++ file: test_set.cpp at 85:44
operator< is a bool function in C++ file: test_set.cpp at 88:6
lhs is a const Set& parameter in C++ file: test_set.cpp at 88:28
rhs is a const Set& parameter in C++ file: test_set.cpp at 88:44
operator>= is a bool function in C++ file: test_set.cpp at 91:6
lhs is a const Set& parameter in C++ file: test_set.cpp at 91:28
rhs is a const Set& parameter in C++ file: test_set.cpp at 91:44
operator> is a bool function in C++ file: test_set.cpp at 94:6
lhs is a const Set& parameter in C++ file: test_set.cpp at 94:28
rhs is a const Set& parameter in C++ file: test_set.cpp at 94:44
NAMECOLLECTOR_SET_HPP_ is a macro in C++ file: test_set.hpp at 2:9
COLLECTION_SIZE is a const unsigned int global in C++ file: test_set.hpp at 6:20
Set is a class in C++ file: test_set.hpp at 9:7
Set is a constructor in C++ file: test_set.hpp at 11:5
Set is a constructor in C++ file: test_set.hpp at 12:5
cardinality is a unsigned int function in C++ file: test_set.hpp at 14:18
operator[] is a bool function in C++ file: test_set.hpp at 15:10
operator+ is a Set function in C++ file: test_set.hpp at 17:9
operator* is a Set function in C++ file: test_set.hpp at 18:9
operator- is a Set function in C++ file: test_set.hpp at 19:9
operator~ is a Set function in C++ file: test_set.hpp at 21:9
operator== is a bool function in C++ file: test_set.hpp at 23:10
operator<= is a bool function in C++ file: test_set.hpp at 24:10
operator<< is a std::ostream& function in C++ file: test_set.hpp at 26:26
member is a bool field in C++ file: test_set.hpp at 29:10
operator!= is a bool function in C++ file: test_set.hpp at 33:6
operator< is a bool function in C++ file: test_set.hpp at 34:6
operator>= is a bool function in C++ file: test_set.hpp at 35:6
operator> is a bool function in C++ file: test_set.hpp at 36:6
main is a int function in C++ file: test_set_main.cpp at 4:5
x is a Set local in C++ file: test_set_main.cpp at 5:9
y is a Set local in C++ file: test_set_main.cpp at 6:9
z is a Set local in C++ file: test_set_main.cpp at 14:9
a is a Set local in C++ file: test_set_main.cpp at 16:9
EOF
)
if [[ "$output" != "$expected" ]]; then
    echo "Test set_pos passed failed!"
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
else
    echo "Test set_pos passed"
fi

exit 0
