/**
 * @file identifierName.hpp
 * Created by Maletic on 6/28/23.
 */
#ifndef IDENTIFIER_NAME_HPP
#define IDENTIFIER_NAME_HPP

#include <iostream>
#include <vector>
#include <string>

//
//The syntactic category types for user defined identifiers.
//
// These are the labels for names produced as output.
//
const std::vector<std::string> IDENTIFIER_TYPES = {
    "function",               //Function name
    "constructor",            //Constructor name
    "destructor",             //Destructor name
    "class",                  //Class name
    "interface",              //Interface name Java
    "typedef",                //Typedef name
    "struct",                 //Struct name
    "union",                  //Union name C, C++
    "enum",                   //Enum name
    "field",                  //Name of a class/struct/union/enum field
    "label",                  //Name of a label (as in goto)
    "local",                  //Local variable name (in a function)
    "global",                 //Gobal variable name
    "macro",                  //Macro name C, C++
    "namespace",              //User defined namespace C++, C#
    "parameter",              //Name of a parameter
    "template-parameter",     //Name of template paramter <typename T> C++
    "function-parameter",     //Name of a parameter, that is a function void *f()
    "property",               //Name of a property C#
    "event",                  //Name of an event C#
    "annotation"              //Name of an annotation Java
};

//
//srcML tag names that have names that are user defined identifiers
//For C/C++, C#, and Java
// Need to add tag names here if you examine that syntactic category for
//  a name.  When adding new languages or constructs
//
const std::vector<std::string> USER_DEFINED_TAGS = {
    "decl",   //For C, C++, C#, Java
    "label",
    "typedef",
    "parameter",
    "function",
    "function_decl",
    "constructor",
    "constructor_decl",
    "destructor",
    "destructor_decl",
    "class",
    "class_decl",
    "interface",  //Java only
    "struct",
    "struct_decl",
    "enum",
    "enum_decl",
    "union",       //C, C++ only
    "union_decl",  //C, C++ only
    "macro",       //C, C++ only
    "namespace",   //C++, C# only
    "event",       //C# only
    "property",    //C# only
    "abstract",    //Java only
    "interface",   //Java only
    "annotation",     //Java only
    "annotation_defn" //Java only
};



//Does this tag contain a user defined name?
//
bool isUserDefinedIdentifier(const std::string category) {
    for (int i=0; i<USER_DEFINED_TAGS.size(); ++i)
        if (category == USER_DEFINED_TAGS[i]) return true;
    return false;
}



// Class to represent user defined identifier names
class identifier {
public:
    identifier() {};
    identifier(const std::string& nm,
               const std::string& cat,
               const std::string& pos) {
        name = nm;
        category = cat;
        position = pos;
    };
    std::string getName() const {return name;};
    std::string getCategory() const {return category;};
    std::string getPosition() const {return position;};

protected:
    std::string name;        //The identifier name
    std::string category;    //Label from IDENTIFIER_TYPES
    std::string position;    //line:column
};

std::ostream& operator<<(std::ostream& out, const identifier& id) {
    out << id.getName() << " at " << id.getPosition()
    << " is a " << id.getCategory();
    return out;
}





#endif