// SPDX-License-Identifier: GPL-3.0-only
/**
 * @file identifierName.hpp
 *
 * @copyright Copyright (C) 2023 srcML, LLC. (www.srcML.org)
 *
 * This file is part of the nameCollector application.
 */
/**
 * Created by Maletic on 6/28/23.
 */
#ifndef IDENTIFIER_NAME_HPP
#define IDENTIFIER_NAME_HPP

#include <iostream>
#include <vector>
#include <unordered_set>
#include <string>

extern bool DEBUG;

//
//The syntactic category types for user defined identifiers.
//
// These are the labels for names produced as output.
//
const std::unordered_set<std::string> IDENTIFIER_TYPES = {
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
const std::unordered_set<std::string> USER_DEFINED_TAGS = {
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

//
//srcML categories that have types AND are named
//For C/C++, C#, and Java
// Need to add categories here if they contain a top-level type tag
//
const std::unordered_set<std::string> TYPED_CATEGORIES = {
    "local",
    "global",
    "field",
    "typedef",
    "parameter",
    "function",
    "function_decl",
    "event", //C# only
    "property" //C# only
};

const std::unordered_set<std::string> STEREOTYPED_CATEGORIES = {
    "function",
    "class",
    "struct",
    "constructor",
    "destructor",
    "interface", // Java only
    "union"
};


//Does this tag contain a user defined name?
//
bool isUserDefinedIdentifier(const std::string& category) {
    return USER_DEFINED_TAGS.find(category) != USER_DEFINED_TAGS.end();
}

// Does this tag contain a type?
bool isTypedCategory(const std::string& category) {
    return TYPED_CATEGORIES.find(category) != TYPED_CATEGORIES.end();
}

// Is this tag stereotypable?
bool isStereotypableCategory(const std::string& category) {
    return STEREOTYPED_CATEGORIES.find(category) != STEREOTYPED_CATEGORIES.end();
}

struct typeInfo {
    std::string type;
    std::string associatedTag;
    bool gatherContent;
};

void replaceSubStringInPlace(std::string& subject, const std::string& search,
                          const std::string& replace) {
    size_t pos = 0;
    while ((pos = subject.find(search, pos)) != std::string::npos) {
         subject.replace(pos, search.length(), replace);
         pos += replace.length();
    }
}

// A user defined identifier and info
class identifier {
public:
    identifier() {};
    identifier(const std::string& nm,
               const std::string& cat,
               const std::string& pos,
               const std::string& st,
               const std::string& fname,
               const std::string& flang,
               const std::string& typ="") {
        name = nm;
        category = cat;
        position = pos;
        stereotype = st;
        filename = fname;
        language = flang;
        type = typ;

    };
    std::string getName()       const {return name;};
    std::string getCategory()   const {return category;};
    std::string getPosition()   const {return position;};
    std::string getStereotype() const {return stereotype;};
    std::string getFilename()   const {return filename;};
    std::string getLanguage()   const {return language;};
    std::string getType()       const {return type;};

protected:
    std::string name;        //The identifier name
    std::string category;    //Label from IDENTIFIER_TYPES
    std::string position;    //line:column
    std::string stereotype;  //Space separated list of stereotypes
    std::string filename;    //File the identifier occurs
    std::string language;    //The programming language the name was in
    std::string type;        //Optional type for decls and functions
};

//CSV output name, category, filename, position
std::ostream& operator<<(std::ostream& out, const identifier& id) {
    out << id.getName()      << "," << id.getType()     << ","
        << id.getCategory()  << "," << id.getFilename() << ","
        << id.getPosition()  << "," << id.getLanguage() << ","
        << id.getStereotype()
        << std::endl;
    return out;
}

//Print out simple report
void printReport(std::ostream& out, const identifier& id) {
    out << id.getName()
        << " is a " << id.getStereotype() << (id.getStereotype() != "" ? " " : "")
        << id.getType() << (id.getType() != "" ? " " : "")
        << id.getCategory()
        << " in " << id.getLanguage() << " file: " << id.getFilename()
        << (id.getPosition() != "" ? ":" : "")  << id.getPosition()
        << std::endl;
}



#endif
