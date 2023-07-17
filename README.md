# nameCollector
A tool for collecting all user defined identifier names from a source code file.  

Works for C, C++, C#, and Java

Input: srcML of a source code file with --position option 

Output: A list of identifier names,  their syntactic type, position (line:column) the identifier occurs (declared), and the file name.  No header is generated.

Example:

| Name            | Type | Position | File |
| --------------- | -------------- |---|---|
|foo| function| 10:5 | foo.cpp |
|x| parameter| 10:15| foo.cpp |
|i| local| 12:10| foo.cpp |


## Identifier Types Supported C, C++, C#, Java:

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


## To build:
- Need libxml2 installed
- Need srcml (develop) installed
- Need srcSAX built and installed

`cmake CMakeList.txt -B build`

`cd build`

`make`


## To run:

Generate the srcML for the given source code file using the --position option.  Then run nameCollector.

`srcml foo.cpp --position -o foo.cpp.xml`

`./nameCollector foo.cpp.xml -f csv -o results.csv`

`./nameCollector --help`

Output is plain text by default.  Use -f csv or --csv for comma separated output.  An output file can be specified with -o option.  The --append option will append output to an existing file rather than overwrite the file.


## Developer Notes:

The initial version of the application was developed by Decker from the srcSAX examples in June 2023.   This was extended to collect the different types of names by Maletic.  Maletic added the CLI11 interface and made the first public release (July 2023). 

Developers of nameCollector:

- Micheal Decker
- Jonathan Maletic
