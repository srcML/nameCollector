#!/bin/bash

cat <<EOF > test_csv_no_header.cpp
#include <vector>
int multiply(int a, int b){
    int return_value = a*b;
    return return_value;
}

// to test that localInsideClassMethod, StaticIntLocal, int nonStaticLocal are categorized as locals and not fields
class Shapes{
    public:

        Shapes();
        Shapes(char): borderCharacter(c) {};

        int calculateArea(int length, int width){ 
            int localInsideClassMethod = length*width; 
            static int StaticIntLocal;
            int nonStaticLocal; 
            return localInsideClassMethod; 
        }; 

    private:
        char borderCharacter; 
};

int main(){
    int k = 8, j, big_number;
    int product = multiply(10, 12);

    for( int i=0; i < 18; i++){
        int next_one = i+1; 
        big_number = multiply(i, next_one);
    }
    //nested locals
    std::vector<int> collection = {1, 2, 3};
    for(auto number:collection){
        if(number%2 == 0){ bool even = true; }
        else {bool odd = false; }
    }
    return 0; 
}
EOF

input=$(srcml test_csv_no_header.cpp --position)
output=$(echo "$input" | ./nameCollector --csv -n)
expected="multiply,int,function,test_csv_no_header.cpp,2:5,C++,
a,int,parameter,test_csv_no_header.cpp,2:18,C++,
b,int,parameter,test_csv_no_header.cpp,2:25,C++,
return_value,int,local,test_csv_no_header.cpp,3:9,C++,
Shapes,,class,test_csv_no_header.cpp,8:7,C++,
Shapes,,constructor,test_csv_no_header.cpp,11:9,C++,
Shapes,,constructor,test_csv_no_header.cpp,12:9,C++,
calculateArea,int,function,test_csv_no_header.cpp,14:13,C++,
length,int,parameter,test_csv_no_header.cpp,14:31,C++,
width,int,parameter,test_csv_no_header.cpp,14:43,C++,
localInsideClassMethod,int,local,test_csv_no_header.cpp,15:17,C++,
StaticIntLocal,static int,local,test_csv_no_header.cpp,16:24,C++,
nonStaticLocal,int,local,test_csv_no_header.cpp,17:17,C++,
borderCharacter,char,field,test_csv_no_header.cpp,22:14,C++,
main,int,function,test_csv_no_header.cpp,25:5,C++,
k,int,local,test_csv_no_header.cpp,26:9,C++,
j,int,local,test_csv_no_header.cpp,26:16,C++,
big_number,int,local,test_csv_no_header.cpp,26:19,C++,
product,int,local,test_csv_no_header.cpp,27:9,C++,
i,int,local,test_csv_no_header.cpp,29:14,C++,
next_one,int,local,test_csv_no_header.cpp,30:13,C++,
collection,std::vector<int>,local,test_csv_no_header.cpp,34:22,C++,
number,auto,local,test_csv_no_header.cpp,35:14,C++,
even,bool,local,test_csv_no_header.cpp,36:33,C++,
odd,bool,local,test_csv_no_header.cpp,37:20,C++,"

if [[ "$output" != "$expected" ]]; then
    echo "Test test_csv_no_header failed!"
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi

echo "Test test_csv_no_header passed!"

exit 0
