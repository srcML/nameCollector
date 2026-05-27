#!/bin/bash

# test the collection of class names, fields, methods in c sharp

cat <<EOF > test_class.cs
using System;

class BasicClass{
    public static string StringField;
    public static int IntField;
    public static double DoubleField;

    public BasicClass(){
        StringField = "Default";
        IntField = 0; 
        DoubleField = 0.1; 
    }

    public BasicClass(string stringVal, int intVal, double doubleVal){
        StringField = stringVal;
        IntField = intVal; 
        DoubleField = doubleVal; 
    }

    public void printValues(){
        Console.WriteLine($"basic class values {StringField}, {IntField}, {DoubleField}");
    }
}

class Program{
    class NestedClass{
        public int NestedClassField;
        public NestedClass(){
            NestedClassField = 0; 
        }
        public void NestedMethod(){
            Console.WriteLine("nested class method");
        }
    }
    
    static int Main(string[] args){
        BasicClass DefaultObj = new BasicClass(); 
        BasicClass AssignedObj = new BasicClass("a string", 10, 2.12);
        NestedClass NCObj = new NestedClass();
        NCObj.NestedMethod();
        AssignedObj.printValues();
        return (0);
    }
}
EOF

input=$(srcml test_class.cs --position)
output=$(echo "$input" | ./nameCollector )
expected="BasicClass is a class in C# file: test_class.cs:3:7
StringField is a public static string field in C# file: test_class.cs:4:26
IntField is a public static int field in C# file: test_class.cs:5:23
DoubleField is a public static double field in C# file: test_class.cs:6:26
BasicClass is a constructor in C# file: test_class.cs:8:12
BasicClass is a constructor in C# file: test_class.cs:14:12
stringVal is a string parameter in C# file: test_class.cs:14:30
intVal is a int parameter in C# file: test_class.cs:14:45
doubleVal is a double parameter in C# file: test_class.cs:14:60
printValues is a public void function in C# file: test_class.cs:20:17
Program is a class in C# file: test_class.cs:25:7
NestedClass is a class in C# file: test_class.cs:26:11
NestedClassField is a public int field in C# file: test_class.cs:27:20
NestedClass is a constructor in C# file: test_class.cs:28:16
NestedMethod is a public void function in C# file: test_class.cs:31:21
Main is a static int function in C# file: test_class.cs:36:16
args is a string[] parameter in C# file: test_class.cs:36:30
DefaultObj is a BasicClass local in C# file: test_class.cs:37:20
AssignedObj is a BasicClass local in C# file: test_class.cs:38:20
NCObj is a NestedClass local in C# file: test_class.cs:39:21"


if [[ "$output" != "$expected" ]]; then
    echo "Test test_cs_class output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got: '$output'"
    exit 1
fi
echo "Test test_cs_class passed!" # all class collected correctly

# Repeat tests

exit 0