# nameCollector
A tool for collecting all user-defined identifier names from a source code file.  

Works for C, C++, C#, and Java

Input: A srcML file of source code with --position option.  srcML file can be a single unit (one source code file) or an archive (multiple source code files).

Output: A list of identifier names,  their type (for declartions and functions), their syntactic category, the file name, and position (line:column) the identifier occurs (declared), the programming langauge, and for methods and classes their stereotype, from [stereocode](https://github.com/srcML/stereocode), if it is in the srcML.  Output is plain text (default) or csv (with no header).

Example:

| Name            | Type     | Category   | File   | Position | Language | Stereotype    |
| --------------- | -------------- | -------- |---|---|---|---|
|foo| char | function | foo.cpp | 10:5 | C++ | get |
|x| double | parameter | foo.cpp | 10:15| C++ |  | 
|i| int | local | foo.cpp | 12:10 | C++ | | 
|stack|   | class | foo.cpp | 15:7| C++ | small-class |

## Identifier Syntactic Categories Supported C, C++, C#, Java:

| Category        | Description |
| --------------- | -------------- |
| function        | Function name |
| constructor     | Constructor name |
| destructor      | Destructor name |
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
| macro           | Macro name in C, C++ |
| namespace       | User defined namespace in C, C++ |
| parameter       | Name of a parameter |
| function-parameter  | Name of a parameter, that is a function | 
| template-parameter  | Name of a template parameter |
| property        | Property name in C# |
| event           | Event name in C# |
| annotation      | Name of an annotation in Java |


## To build:
- Need libxml2 installed
- Need [srcML](https://srcML.org) develop installed
- Need [srcSAX](https://github.com/srcML/srcSAX)  built and installed  

`cmake CMakeList.txt -B build`

`cd build`

`make`


## To run:

Generate the srcML for the given source code file using the --position option.  Then run nameCollector.

`srcml foo.cpp --position -o foo.cpp.xml`

`./nameCollector -i foo.cpp.xml --csv -o results.csv`

`./nameCollector --help`

Output is plain text by default.  Use -f csv or --csv for comma separated output.  An output file can be specified with -o option. Takes standard input by default, and an input file can be specified with -i.  The --append option will append output to an existing file rather than overwrite the file.

## To Run Tests:
From the source directory run the following commands to build nameCollector:

`cmake CMakeLists.txt -B build`

`cd build`

`make`

To run the tests defined in the testsuite directory use the following command:

`make test`

Once the test command is run you can check out the results of the tests by navigating to the `/Testing` subdirectory in the build directory, from here you can access the `LastTest.log` and `LastTestsFailed.log` files to view the test results.

## Developer Notes:

The initial version of the application was developed by Decker from the srcSAX examples in June 2023.   This was extended to collect the different types of names by Maletic.  Maletic added the CLI11 interface and made the first public release (July 2023). 

nameCollector is a good simple example of how to use srcSAX to build fast and scalable tools for collecting analysis information.

Developers of nameCollector:
- Michael Collard
- Michael Decker
- Jonathan Maletic
- Joshua Behler

