// SPDX-License-Identifier: GPL-3.0-only
/**
 * @file cFamilyNameCollectorHandler.hpp
 *
 * @copyright Copyright (C) 2023-2026 srcML, LLC. (www.srcML.org)
 *
 * This file is part of the nameCollector application.
 */


#ifndef INCLUDED_C_FAMILY_NAME_COLLECTOR_HANDLER_HPP
#define INCLUDED_C_FAMILY_NAME_COLLECTOR_HANDLER_HPP

#include <libxml/xmlwriter.h>
#include <srcSAXHandler.hpp>
#include <cppCallbackAdapter.hpp>

#include "identifierName.hpp"
#include "versionedString.hpp"

#include <iostream>
#include <string>
#include <vector>
#include <unordered_map>

extern bool DEBUG;

class cFamilyNameCollectorHandler : public srcSAXHandler {
public:
    cFamilyNameCollectorHandler() : collectContent(false), content(), position(), usePreviousPosition(false), inIndexCount(0), complexNameCount(0), previousComplexName() {};
    cFamilyNameCollectorHandler(std::ostream* ptr, bool csv, bool noHeader) : collectContent(false), content(), position(), usePreviousPosition(false), inIndexCount(0), complexNameCount(0), previousComplexName(), outPtr(ptr), outputCSV(csv), printHeader(!noHeader){};
    virtual ~cFamilyNameCollectorHandler() {};


#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

    /**
     * startDocument
     *
     * SAX handler function for start of document.
     * Write start of xml document.
     *
     * Override for desired behaviour.
     */
    virtual void startDocument() { }

    /**
     * endDocument
     *
     * SAX handler function for end of document.
     * Write the end of xml document.
     *
     * Override for desired behaviour.
     */
    virtual void endDocument() { }

    /**
     * startRoot
     * @param localname the name of the element tag
     * @param prefix the tag prefix
     * @param URI the namespace of tag
     * @param num_namespaces number of namespaces definitions
     * @param namespaces the defined namespaces
     * @param nb_attributes the number of attributes on the tag
     * @param attributes list of attributes
     *
     * SAX handler function for start of the root element.
     * Write out the root start tag (unless non-archive, startUnit will handle).
     *
     * Override for desired behaviour.
     */
    virtual void startRoot(const char* localname, const char* prefix, const char* URI,
                           int numNamespaces, const struct srcsax_namespace * namespaces, int numAttributes,
                           const struct srcsax_attribute * attributes) { }

    /**
     * startUnit
     * @param localname the name of the element tag
     * @param prefix the tag prefix
     * @param URI the namespace of tag
     * @param num_namespaces number of namespaces definitions
     * @param namespaces the defined namespaces
     * @param nb_attributes the number of attributes on the tag
     * @param attributes list of attributes
     *
     * SAX handler function for start of an unit.
     * Write out any saved text, then write out the unit tag.
     *
     * Override for desired behaviour.
     */
    virtual void startUnit(const char* localname, const char* prefix, const char* URI,
                           int numNamespaces, const struct srcsax_namespace * namespaces, int numAttributes,
                           const struct srcsax_attribute * attributes) { 
        const std::string localName = localname;

        srcFileLanguage = "unknown";
        if (numAttributes >= 2)
            srcFileLanguage = attributes[1].value;

        srcFileName = "unknown";
        if (numAttributes >= 3)
            srcFileName = attributes[2].value;
        
        elementStack.push_back(localName);
        diffStack.push_back(COMMON);
    }

    /**
     * startElement
     * @param localname the name of the element tag
     * @param prefix the tag prefix
     * @param URI the namespace of tag
     * @param num_namespaces number of namespaces definitions
     * @param namespaces the defined namespaces
     * @param nb_attributes the number of attributes on the tag
     * @param attributes list of attributes
     *
     * SAX handler function for start of an element.
     * Write out any saved text, then write out the elementtag.
     * 
     * Override for desired behaviour.
     */
    virtual void startElement(const char* localname, const char* prefix, const char* URI,
                              int numNamespaces, const struct srcsax_namespace * namespaces,
                              int numAttributes, const struct srcsax_attribute * attributes) {
          // check localname if it is a name and look at stack to see what it is in.
          // names can be nested, so you might only want to do this for top-level names
          // If you want to gather the text, then you need to set a flag when you start collecting (start_element)
          // stop when down (end_element)


          // this is adding all elements, so you might only want to push certain elements

        std::string back = "";
        if (!elementStack.empty()) back = elementStack.back();

        std::string localName = localname;

        // record diff elements on stack, ignore otherwise
        if (URI == DIFF_NAMESPACE) {
            diffOperation op = getDiffOp(localName);
            if (op != NONE) {
                diffStack.push_back(op);
            }
            return;
        }

        if (back == "name" && localName == "name")                 // Top-level Names
            elementStack.push_back("name_2");
        else if (back.find("name_") == 0 && localName == "name") { // Sub-names in complex names
            int depth = std::stoi(back.substr(5));
            elementStack.push_back("name_" + std::to_string(depth+1));
        } else if (back == "name" && localName == "operator")      // Operators in top-level names
            elementStack.push_back("operator_name_2");
        else if (back.find("name_")==0 && localName=="operator") { // Operators in sub-names
            int depth = std::stoi(back.substr(5));
            elementStack.push_back("operator_name_" + std::to_string(depth+1));
        } else if(localName == "parameter_list") {                 // Check parameter_list for type="generic"
            bool add_generic = false;
            for (int i = 0; i < numAttributes; ++i) {
                if (std::string(attributes[i].localname) == "type" && std::string(attributes[i].value) == "generic") {
                    add_generic = true;
                    break;
                }
            }
            elementStack.push_back(add_generic ? "generic_parameter_list" : localName);
        } else if (localName == "expr" && srcFileLanguage == "C#" && elementStack.size() >= 2 && elementStack[elementStack.size()-1] == "init" && elementStack[elementStack.size()-2] == "using") {
            // If this is the expression in the init of a C# using statement, treat it like a type instead
            elementStack.push_back("type");
            localName = "type";
        } else { // All other tags
            elementStack.push_back(localName);
        }

        if (localName == "name" && inIndexCount == 0) {
            collectContent = true;

            // Get position info if it exists
            for (int i = 0; i < numAttributes; ++i) {
                if (std::string(attributes[i].prefix) == "pos" && std::string(attributes[i].localname) == "start") {
                    previousPosition = position;
                    position = attributes[i].value;
                    break;
                }
            }
        } 
        else if (localName == "type") {
            // Check if this is a type ref=prev
            bool isPrevType = false;
            for (int i = 0; i < numAttributes; ++i) {
                if (std::string(attributes[i].localname) == "ref") {
                    isPrevType = true;
                }
            }
            if (isPrevType) { } // ignore if it is
            else {
                typeInfo insertType;
                // If parent tag is a decl, check if grandparent is decl_stmt.
                // If so, make decl_stmt the associated tag
                if (elementStack.size() >= 3 && elementStack[elementStack.size()-2] == "decl" && elementStack[elementStack.size()-3] == "decl_stmt")
                    insertType.associatedTag = "decl_stmt";
                // if parent tag is an init, check if grandparent is using
                // if so, make using the associated tag
                else if (elementStack.size() >= 3 && elementStack[elementStack.size()-2] == "init" && elementStack[elementStack.size()-3] == "using")
                    insertType.associatedTag = "using";
                else
                    insertType.associatedTag = elementStack.size() >= 2 ? elementStack[elementStack.size()-2] : "";
                insertType.gatherContent = true;
                typeStack.push_back(insertType);
            }
        }

        if (localName == "index") {
            ++inIndexCount;
            collectContent = false;
        }
        
        //Need to collect some type info for struct and anonymous struct
        // struct { } x;      // x has type struct
        if (isStruct(localName) && (srcFileLanguage == "C++" || srcFileLanguage == "C")) {
            typeInfo insertType;
            insertType.associatedTag = localName; //struct, class, enum, union
            insertType.gatherContent = true;
            typeStack.push_back(insertType);
        } 
        
        //Stop gathering contents of structs when a block is encountered
        if ((localName == "block") && !typeStack.empty()) {
            if (isStruct(typeStack[typeStack.size()-1].associatedTag)) {
                typeStack[typeStack.size()-1].gatherContent = false;
            }
        }
 
        if (isStereotypableCategory(localName)) {
            // Check for stereotype information from stereocode
            for (int i = 0; i < numAttributes; ++i) {
                if (attributes[i].prefix != 0 && std::string(attributes[i].prefix) == "st" && std::string(attributes[i].localname) == "stereotype") {
                    stereotypeStack.push_back(attributes[i].value);
                    break;
                }
            }
        }
    }

    /**
     * endRoot
     * @param localname the name of the element tag
     * @param prefix the tag prefix
     * @param URI the namespace of tag
     *
     * SAX handler function for end of the root element.
     * Write out any saved content, then end the root tag.
     *
     * Override for desired behaviour.
     */
    virtual void endRoot(const char* localname, const char* prefix, const char* URI) { }

    /**
     * endUnit
     * @param localname the name of the element tag
     * @param prefix the tag prefix
     * @param URI the namespace of tag
     *
     * SAX handler function for end of an unit.
     * Write out any saved up content, then write out ending unit tag.
     *
     * Override for desired behaviour.
     */
    virtual void endUnit(const char* localname, const char* prefix, const char* URI) { 

        if (!elementStack.empty())    elementStack.clear();
        if (!typeStack.empty())       typeStack.clear();
        if (!stereotypeStack.empty()) stereotypeStack.clear();

        cppCallbackAdapter* adapter = (cppCallbackAdapter*)(this->context->data);
        adapter->pop_handler();
        adapter->get_handler()->endUnit(localname, prefix, URI);

    }

    /**
     * endElement
     * @param localname the name of the element tag
     * @param prefix the tag prefix
     * @param URI the namespace of tag
     *
     * SAX handler function for end of an element.
     * Write out any saved content, then write out ending element tag.
     *
     * Override for desired behaviour.
     */
    virtual void endElement(const char* localname, const char* prefix, const char* URI) { 

        std::string category;
        bool isComplexName = false;

        std::string localName = localname;

        // If this is the expression in the init of a C# using statement, treat it like a type instead
        if (localName == "expr" && srcFileLanguage == "C#" && elementStack.size() >= 3 && elementStack[elementStack.size()-2] == "init" && elementStack[elementStack.size()-3] == "using") {
            localName = "type";
        }

        // remove diff element from stack, ignore otherwise
        if (URI == DIFF_NAMESPACE) {
            diffOperation op = getDiffOp(localName);
            if (op != NONE) {
                diffStack.pop_back();
            }
            return;
        }

        if (localName == "name" && content != "" && inIndexCount == 0)  {
            size_t nameDepth = 0;
            if (!elementStack.empty() && elementStack.back() == "name") {
                category = elementStack.size() >= 2 ? elementStack[elementStack.size()-2] : ""; //Normal name
                nameDepth = 1;
                complexNameCount = 0;
            }
            else if (!elementStack.empty()) {
                nameDepth = std::stoi(elementStack.back().substr(5));
                category = elementStack.size() >= (nameDepth + 1) ? elementStack[elementStack.size()-(nameDepth+1)] : "";
                isComplexName = true;
            }

            if (isComplexName) {
                ++complexNameCount;
            }

            // if this is a namespace in a using, do not collect it
            if (category == "namespace" && elementStack.size() >= 3 && elementStack[elementStack.size() - 2] == "namespace" && elementStack[elementStack.size() - 3] == "using") {
                category = "";
            }

            //Only interested in user defined identifiers
            if (isUserDefinedIdentifier(category)) {
                if (category == "class_decl")       category = "class";
                if (category == "enum_decl")        category = "enum";
                if (category == "struct_decl")      category = "struct";
                if (category == "union_decl")       category = "union";
                if (category == "constructor_decl") category = "constructor";
                if (category == "destructor_decl")  category = "destructor";
                if (category == "annotation_defn")  category = "annotation";
                if (category == "package")          category = "namespace";
                if (category == "function_decl") {
                    if (elementStack.size() >= 3 && elementStack[elementStack.size()-3] == "parameter")
                        category = "function-parameter";
                    else if (elementStack.size() >= 3 && elementStack[elementStack.size()-3] == "typedef")
                        category = "typedef";
                    else
                        category = "function";
                }

                if (content.find("operator") != std::string::npos && srcFileLanguage == "C++" && category == "function") {
                    usePreviousPosition = true;
                }

                //Deal with complex function names
                //If it is a function name, collect the complex name ex. String::length, String::operator+=
                //If it is a decl collect simple name only
                if (((category == "destructor") || (category == "constructor") || (category == "function") || (category == "decl")) && ((!elementStack.empty()) && (elementStack.back() != "name"))) {
                    if (!elementStack.empty()) elementStack.pop_back();
                    return;
                }

                if (category == "parameter") {
                    if (isGenericParameter()) category = "generic-parameter";
                }
                if (category == "decl") { //Need additional checks
                    category = "global";
                    if (isParameter())  category = "parameter";
                    else {
                        if (isLocal()) category = "local";
                        if (isField()) category = "field";
                    }
                }

                //Get type from type stack of <type> and <struct>
                //Deals with anonymous struct etc.
                std::string type = "";
                if (isTypedCategory(category) && typeStack.size() >= 1) {
                    if ((category == "field") && (typeStack[typeStack.size()-1].type.find("enum") != std::string::npos)) {
                        type = "";  //Deal with enum fields without a type
                    }
                    else if ((category == "function") && elementStack.size() >= 4 && elementStack[elementStack.size()-4] == "property") {
                        type = ""; //Deal with functions `get`, `set`, etc. in properties
                    }
                    else if (category == "parameter" && typeStack.size() >= 1 && typeStack.back().associatedTag != "decl") {
                        type = "";
                    }
                    else {
                        //Deal with typedefs with structs etc.
                        if (typeStack.size() >= 1 && typeStack[typeStack.size()-1].associatedTag == "typedef") {
                            type = typeStack[typeStack.size()-1].type;
                            size_t blank = type.find(' ');
                            if (blank != std::string::npos) {
                                if (type.substr(0, blank).find("struct")!= std::string::npos) type = "struct";
                                if (type.substr(0, blank).find("enum")!= std::string::npos) type = "enum";
                                if (type.substr(0, blank).find("class")!= std::string::npos) type = "class";
                                if (type.substr(0, blank).find("union")!= std::string::npos) type = "union";
                            }
                        }
                        else
                            type = typeStack.size() >= 1 ? typeStack[typeStack.size()-1].type : "";

                        if (typeStack.size() >= 1 && type == typeStack[typeStack.size()-1].associatedTag + " ")
                            replaceSubStringInPlace(type, " ", "");
                        if (typeStack.size() >= 1 && isStruct(typeStack[typeStack.size()-1].associatedTag)) {
                            replaceSubStringInPlace(type, typeStack[typeStack.size()-1].associatedTag + " ", "");  //Remove "struct " from type
                            replaceSubStringInPlace(type, "class ", "");  //Deal with enum class foo {};
                            replaceSubStringInPlace(type, " ", "");
                        }
                    }
                }
                else if (category == "generic-parameter" && srcFileLanguage == "C++" && typeStack.size() >= 1 && typeStack.back().associatedTag == "parameter") {
                    type = typeStack.back().type;
                }
                if (elementStack.size() >= 3 && elementStack[elementStack.size()-2] == "function_decl" && elementStack[elementStack.size()-3] == "typedef") {
                    type += " function";
                }

                std::string stereotype = (isStereotypableCategory(category) && !stereotypeStack.empty() ?
                                          stereotypeStack[stereotypeStack.size() - 1] : "");
                if (!stereotypeStack.empty()) stereotypeStack.pop_back();

                //Remove any prefix String:: from context - for functions
                if (content.find("::") != std::string::npos) {
                    content.erase("::");
                }

                if (usePreviousPosition) {
                    position = previousPosition;
                    usePreviousPosition = false;
                }

                //Output results

                if (outputCSV) {
                    *outPtr << identifier(content, category, position, stereotype, srcFileName, srcFileLanguage, type);
                } else {
                    printReport(*outPtr, identifier(content, category, position, stereotype, srcFileName, srcFileLanguage, type));
                }

                if (DEBUG) {  //Print identifier and stacks
                    std::cerr << "Identifier: " << content << std::endl;
                    std::cerr << "Category: " << category << std::endl;
                    std::cerr << "Position: " << position << std::endl;
                    std::cerr << "Stereotype: " << stereotype << std::endl;
                    std::cerr << "Type: " << type << std::endl;
                    std::cerr << "Element Stack: ";
                    for (int i=elementStack.size()-1; i>=0; --i) { std::cerr << elementStack[i] << " | "; }
                    std::cerr << std::endl;
                    std::cerr << "Type Stack: ";
                    for (int i=typeStack.size()-1; i>=0; --i) { std::cerr << "[" << typeStack[i].type << ", " << typeStack[i].associatedTag << "]"  << " | "; }
                    std::cerr << std::endl;
                    std::cerr << "------------------------" << std::endl;
                }
            } else if (category == "using") {
                typeAfterNameContent = content;
                typeAfterNamePosition = position;
            } 

            if (isComplexName) {
                previousComplexName = content;
            }

            content.clear();
            position = "";

            collectContent = false;
        }
        

        if (localName == "index") {
            --inIndexCount;
        }
        
        // if ending the init of a using, it is a typedef
        if (localName == "init" && elementStack.size() >= 2 && elementStack[elementStack.size()-2] == "using") {
            if (outputCSV) {
                *outPtr << identifier(typeAfterNameContent, "typedef", typeAfterNamePosition, "", srcFileName, srcFileLanguage, typeStack[typeStack.size()-1].type);
            } else {
                printReport(*outPtr, identifier(typeAfterNameContent, "typedef", typeAfterNamePosition, "", srcFileName, srcFileLanguage, typeStack[typeStack.size()-1].type));
            }

            if (DEBUG) {  //Print identifier and stacks
                std::cerr << "Identifier: " << typeAfterNameContent << std::endl;
                std::cerr << "Category: " << "typedef" << std::endl;
                std::cerr << "Position: " << typeAfterNamePosition << std::endl;
                std::cerr << "Stereotype: " << "" << std::endl;
                std::cerr << "Type: " << typeStack[typeStack.size()-1].type << std::endl;
                std::cerr << "Element Stack: ";
                for (int i=elementStack.size()-1; i>=0; --i) { std::cerr << elementStack[i] << " | "; }
                std::cerr << std::endl;
                std::cerr << "Type Stack: ";
                for (int i=typeStack.size()-1; i>=0; --i) { std::cerr << "[" << typeStack[i].type << ", " << typeStack[i].associatedTag << "]"  << " | "; }
                std::cerr << std::endl;
                std::cerr << "------------------------" << std::endl;
            }
        }

        if (typeStack.size() >= 1 && localName == "type") {
            typeStack[typeStack.size()-1].gatherContent = false;
        } 

        // Note: struct gather content for typename turns off in endElement at block
        if (typeStack.size() >= 1 && typeStack[typeStack.size()-1].associatedTag == localName) {
            typeStack.pop_back();
        }

        if (localName == "namespace" && category != "" && !elementStack.empty() && element_stack.back() == "init") {
            elementStack.pop_back();  // Deal with namespace foo = x::y;
        }

        std::string last_popped = "";
        if (!elementStack.empty()) {
            last_popped = elementStack.back();
            elementStack.pop_back();
        }

        //Address namespace foo = x::y;
        // Push an init on stack after first name, only if not in form `namespace A::B`.  Then make sure to
        //  pop it off at end of </namespace>
        if (category == "namespace") {
            if (last_popped != "name_2") {
                elementStack.push_back("init");  // Deal with namespace foo = x::y;
            }
        }

        
    }

    /**
     * charactersRoot
     * @param ch the characers
     * @param len number of characters
     *
     * SAX handler function for character handling at the root level.
     * Collect/write root level charactes.
     * 
     * Characters may be called multiple times in succession
     * in some cases the text may need to be gathered all at once
     * before output. Both methods are shown here although the delayed
     * output is used.
     *
     * Override for desired behaviour.
     */
    virtual void charactersRoot(const char* ch, int len) { }

    /**
     * charactersUnit
     * @param ch the characers
     * @param len number of characters
     *
     * SAX handler function for character handling within a unit.
     * Collect/write unit level charactes.
     * 
     * Characters may be called multiple times in succession
     * in some cases the text may need to be gathered all at once
     * before output. Both methods are shown here although the delayed
     * output is used.
     * 
     * Override for desired behaviour.
     */
    virtual void charactersUnit(const char* ch, int len) {
        /*  Characters may be called multiple times in succession
            in some cases the text may need to be gathered all at once
            before output. Both methods are shown here although the delayed
            output is used.
        */
        if (collectContent) {
            content.append((const char *)ch, len, diffStack.back());
        }
        for (auto& type : typeStack)
            if (type.gatherContent)
                type.type.append((const char *)ch, len);
    }

#pragma GCC diagnostic pop

private:

    bool isParameter() const {
        int i=elementStack.size()-1;
        while (i > 0) {
            if (elementStack[i] == "parameter") return true;
            --i;
        }
        return false;
    }

    bool isGenericParameter() const {
        int i=elementStack.size()-1;
        while (i > 0) {
            if (elementStack[i] == "template" || elementStack[i] == "generic_parameter_list") return true;
            --i;
        }
        if (srcFileLanguage == "Java") {
            if (elementStack.size() >= 5 && (isStruct(elementStack[elementStack.size()-5])) && elementStack[elementStack.size()-4] == "name" && elementStack[elementStack.size()-3] == "parameter_list" && elementStack[elementStack.size()-2] == "parameter")
                return true;
        }
        return false;
    }

    //Needs to check for name after struct/class/union/enum
    // struct {int x;} foo;  -- this is not a field but a local/global
    // Need to deal with nested structs as fields
    // Fields have a "block | struct" someplace on stack
    // Also needs to check if in a function within a class decl (local)
    bool isField() const {
        int  i        = elementStack.size()-1;
        while (i > 0) {
            if (elementStack[i] == "function" || elementStack[i] == "constructor" || elementStack[i] == "destructor") return false;
            if ((elementStack[i] == "block") &&  isStruct(elementStack[i-1])) return true;
            --i;
        }
        return false;
    }

    bool isLocal() const {
        int i=elementStack.size()-1;
        while (i > 0) {
            if (elementStack[i] == "function" || elementStack[i] == "constructor" || elementStack[i] == "destructor")
                return true;
            --i;
        }
        return false;
    }

    bool                     collectContent;       //Flag to collect characters
    versionedString          content;              //Content collected
    std::string              position;             //The position of content
    std::string              previousPosition;     //The last gathered position - important for operator functions
    bool                     usePreviousPosition;  //A flag that specifies whether to use the previous position for output
    std::vector<std::string> stereotypeStack;      //Optional stereotype info of funcs/classes
    std::vector<std::string> elementStack;         //Stack of srcML tags
    int                      inIndexCount;
    int                      complexNameCount;
    std::string              previousComplexName;
    std::string              typeAfterNameContent; //Storage location for a name whose type info appears after it
    std::string              typeAfterNamePosition;//Storage location for a name's position whose type info appears after it
    std::vector<identifier>  expressionNames;      //List of expression names, which can't be output in order
    std::string              srcFileName;          //Current source code file name (vs xml)
    std::string              srcFileLanguage;      //Current source code language
    std::vector<typeInfo>    typeStack;            //Stack of recent types
    std::ostream*            outPtr;               //Pointer to the output stream
    bool                     outputCSV;            //True is csv, False is report
    bool                     printHeader;          //print csv column header

    // srcDiff Features
    diffOperation getDiffOp(const std::string& diffElement) {
        typedef std::unordered_map<std::string, diffOperation> DiffElementMap;
        static const DiffElementMap diffElementMap = { { "delete", DELETE },
                                                       { "insert", INSERT },
                                                       { "common", COMMON },
                                                     };
        DiffElementMap::const_iterator itr = diffElementMap.find(diffElement);
        return itr != diffElementMap.end() ? itr->second : NONE;
    }

    const std::string DIFF_NAMESPACE = "http://www.srcML.org/srcDiff";
    std::vector<diffOperation> diffStack;                              //Stack of diff operations

};

#endif