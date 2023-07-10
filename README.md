# nameCollector
A tool for getting all user defined identifier names.  

Works for C, C++, C#, and Java

# Identifier Types

| Type            | Description |
| --------------- | -------------- |
| function        | Function name |
| constructor     | Constructor name |
| destructor      |  Destructor name |
| class           | Class name |
| interface       | Interface name in Java |
| typedef         | Typedef name |
| struct          | Struct name |
| union           | Union name in C, C++|
| enum            | Enum name |
| field           | Name of a class/struct/union/enum field |
| label           | Name of a label (as in goto) |
| local           | Local variable name (in a function) |
| global          | Gobal variable name |
| macro          | Macro name in C, C++ |
| namespace          | User defined namespace in C, C# |
| parameter       | Name of a parameter |
| function-parameter  | Name of a parameter, that is a function | 
| template-parameter       | Name of a template parameter |
| property       | Property name in C# |
| event       | Event name in C# |
| annotation       | Name of an annotation in Java |


# To build:
- Need libxml2 installed
- Need srcml (develop) installed
- Need srcSAX built and installed

`
cmake CMakeList.txt -B build

cd build

make
`


# To run:

Prints out all the user defined identifier names, the syntactic category, and position in file.
It takes a single file in srcML using --position option.

`
srcml foo.cpp --position -o foo.cpp.xml

./nameCollector foo.cpp.xml
`


