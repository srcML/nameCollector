// SPDX-License-Identifier: GPL-3.0-only
/**
 * @file nameCollectorHandler.cpp
 *
 * @copyright Copyright (C) 2013-2023 srcML, LLC. (www.srcML.org)
 *
 * This file is part of the nameCollector application.
 */

/** Modified by MaleticJuly 2023.
 *
 *  Collects all user defined names in a given C, C++, C#, Java file
 *
 */

#ifndef INCLUDED_NAME_COLLECTOR_HANDLER_HPP
#define INCLUDED_NAME_COLLECTOR_HANDLER_HPP

#include <libxml/xmlwriter.h>
#include <srcSAXHandler.hpp>
#include <iostream>
#include <string>
#include <vector>

#include "identifierName.hpp"

extern bool DEBUG;

struct scope {
    std::string type;
    std::unordered_set<std::string> names;
};

/**
 * nameCollectorHandler
 * Base class that provides hooks for SAX processing
 *
 * This handler works on srcML input - single unit or multi-unit archive.
 * It collects all the names in the archive.
 *
 * It creates a stack so the syntactic category of the name can be determined.
 *  Constructs a vector of (name, syntactic type, pos, file)
 *
 *  ("foo", "function", "10:6", foo.cpp)
 *  A function foo at line 10, column 6 in foo.cpp
 *  
 */
class nameCollectorHandler : public srcSAXHandler {
public:
    nameCollectorHandler() : collectContent(false), content(), position(), usePreviousPosition(false), collectOpContent(false), opContent(), complexNameCount(0), previousComplexName() {};
    nameCollectorHandler(std::ostream* ptr, bool csv) : collectContent(false), content(), position(), usePreviousPosition(false), collectOpContent(false), opContent(), complexNameCount(0), previousComplexName(), outPtr(ptr), outputCSV(csv) {};
    ~nameCollectorHandler() {};

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

    /**
     * startDocument
     *
     * SAX handler function for start of document.
     * Write start of xml document.
     *
     * Overide for desired behaviour.
     */
    virtual void startDocument() {
    }

    /**
     * endDocument
     *
     * SAX handler function for end of document.
     * Write the end of xml document.
     *
     * Overide for desired behaviour.
     */
    virtual void endDocument() {
    }

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
     * Overide for desired behaviour.
     */
    virtual void startRoot(const char* localname, const char* prefix, const char* URI,
                           int numNamespaces, const struct srcsax_namespace * namespaces, int numAttributes,
                           const struct srcsax_attribute * attributes) {

    }

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
     * Overide for desired behaviour.
     */
    virtual void startUnit(const char* localname, const char* prefix, const char* URI,
                           int numNamespaces, const struct srcsax_namespace * namespaces, int numAttributes,
                           const struct srcsax_attribute * attributes) {

        if (DEBUG) {  //Print out attributes on <unit>
            std::cerr << "Attributes on UNIT: " << std::endl;
            for (int i=0; i<numAttributes; ++i)
                std::cerr << attributes[i].value << std::endl;
        }

        srcFileLanguage = "unknown";
        if (numAttributes >= 1)
            srcFileLanguage = attributes[1].value;

        srcFileName = "unknown";
        if (numAttributes >= 2)
            srcFileName = attributes[2].value;

        elementStack.push_back(localname);

        if (isNoDeclLanguage()) {
            scope globalScope;
            globalScope.type = "global";
            scopeStack.push_back(globalScope);
        }
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
     * Overide for desired behaviour.
     */
    virtual void startElement(const char* localname, const char* prefix, const char* URI,
                              int numNamespaces, const struct srcsax_namespace * namespaces,
                              int numAttributes, const struct srcsax_attribute * attributes) {

          // check localname if it is a name and look at stack to see what it is in.
          // names can be nested, so you might only want to do this for top-level names
          // If you want to gather the text, then you need to set a flag when you start collecting (start_element)
          // stop when down (end_element)


          // this is adding all elements, so you might only want to push certain elements

        std::string back = elementStack.back();

        if (back == "name" && std::string(localname) == "name")                 // Top-level Names
            elementStack.push_back("name_2");
        else if (back.find("name_") == 0 && std::string(localname) == "name") { // Sub-names in complex names
            int depth = std::stoi(back.substr(5));
            elementStack.push_back("name_" + std::to_string(depth+1));
        } else if (back == "name" && std::string(localname) == "operator")      // Operators in top-level names
            elementStack.push_back("operator_name_2");
        else if (back.find("name_")==0 && std::string(localname)=="operator") { // Operators in sub-names
            int depth = std::stoi(back.substr(5));
            elementStack.push_back("operator_name_" + std::to_string(depth+1));
        } else if(std::string(localname) == "parameter_list") {                 // Check parameter_list for type="generic"
            bool add_generic = false;
            for (int i = 0; i < numAttributes; ++i) {
                if (std::string(attributes[i].localname) == "type" && std::string(attributes[i].value) == "generic") {
                    add_generic = true;
                    break;
                }
            }
            elementStack.push_back(add_generic ? "generic_parameter_list" : localname);
        } else {                                                                // All other tags
            elementStack.push_back(localname);
        }

        if (std::string(localname) == "name") {
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
        else if (std::string(localname) == "type") {
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
                if (elementStack[elementStack.size()-2] == "decl" && elementStack[elementStack.size()-3] == "decl_stmt")
                    insertType.associatedTag = "decl_stmt";
                else
                    insertType.associatedTag = elementStack[elementStack.size()-2];
                insertType.gatherContent = true;
                typeStack.push_back(insertType);
            }
        }
        else if (std::string(localname) == "from" && elementStack[elementStack.size()-2] == "import") {
            elementStack[elementStack.size()-2] = "from-import";
        }

        if (isNoDeclLanguage() && std::string(localname) == "operator") {
            collectOpContent = true;
        }

        // If in a no decl language, need to keep track of scope
        if (isNoDeclLanguage() && (std::string(localname) == "function" || std::string(localname) == "lambda")) {
            scope functionScope;
            functionScope.type = "function";
            scopeStack.push_back(functionScope);
        }
        else if (isNoDeclLanguage() && std::string(localname) == "class") {
            scope classScope;
            classScope.type = "class";
            scopeStack.push_back(classScope);
        }
        
        //Need to collect some type info for struct and anonymous struct 
        // struct foo { } x;  // x has type foo
        // struct { } x;      // x has type struct
        if (isStruct(std::string(localname))) {
            typeInfo insertType;
            insertType.associatedTag = std::string(localname); //struct, class, enum, union
            insertType.gatherContent = true;
            typeStack.push_back(insertType);
        } 
        
        //Stop gathering contents of structs when a block is encountered
        if ((std::string(localname) == "block") && (typeStack.size() != 0)) {
            if (isStruct(typeStack[typeStack.size()-1].associatedTag)) {
                typeStack[typeStack.size()-1].gatherContent = false;
            }
        }
        
        if (isStereotypableCategory(localname)) {
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
     * Overide for desired behaviour.
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
     * Overide for desired behaviour.
     */
    virtual void endUnit(const char* localname, const char* prefix, const char* URI) {
        elementStack.pop_back();
        if (scopeStack.size() != 0) scopeStack.pop_back();
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
     * Overide for desired behaviour.
     */
    virtual void endElement(const char* localname, const char* prefix, const char* URI) {
        std::string category;
        bool isComplexName = false;
        if ((std::string(localname) == "name") && (content != ""))  {
            int nameDepth = 0;
            if (elementStack.back() == "name") {
                category = elementStack[elementStack.size()-2]; //Normal name
                nameDepth = 1;
                complexNameCount = 0;
            }
            else {
                nameDepth = std::stoi(elementStack.back().substr(5));
                category = elementStack[elementStack.size()-(nameDepth+1)];
                isComplexName = true;
            }

            if (isComplexName) {
                ++complexNameCount;
            }

            // If in a no decl language AND category is expr, go a level higher
            if (isNoDeclLanguage() && category == "expr") {
                std::string expr_category = elementStack[elementStack.size()-(nameDepth+2)];
                if (expr_category == "expr_stmt" ||
                    expr_category == "condition" ||
                    expr_category == "alias"     ||
                    expr_category == "control") {
                    category = expr_category;
                }
                else if (expr_category == "tuple" ||
                         expr_category == "array") {
                    nameDepth += 2;
                    expr_category = elementStack[elementStack.size()-(nameDepth+2)];
                    if (expr_category == "expr_stmt" ||
                        expr_category == "control") {
                        category = expr_category;
                    }
                }
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
                if (category == "function_decl") {
                    if (elementStack[elementStack.size()-3] == "parameter")
                        category = "function-parameter";
                    else
                        category = "function";
                }

                if (content.find("operator") != std::string::npos && srcFileLanguage == "C++" && category == "function") {
                    usePreviousPosition = true;
                }

                //Deal with complex function names
                //If it is a function name, collect the complex name ex. String::length, String::operator+=
                //If it is a decl collect simple name only
                if (((category == "destructor") || (category == "constructor") || (category == "function")) && (elementStack.back() != "name")) {
                    elementStack.pop_back();
                    return;
                }

                if (category == "parameter") {
                    if (isNoDeclLanguage()) scopeStack.back().names.insert(content);
                    if (isTemplateParameter()) category = "template-parameter";
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
                std::string type = "";
                if (isTypedCategory(category) && (typeStack.size() != 0) && !isUntypedLanguage()) {
                    if ((category == "field") && (typeStack[typeStack.size()-1].type.find("enum") != std::string::npos)) {
                        std::string type = "";  //Deal with enum fields without a type
                    } else {
                        type = typeStack[typeStack.size()-1].type;
                        replaceSubStringInPlace(type, ",", "&#44;");
                        replaceSubStringInPlace(type, "\n", "");
                        if (type == typeStack[typeStack.size()-1].associatedTag + " ")
                            replaceSubStringInPlace(type, " ", "");
                        if (isStruct(typeStack[typeStack.size()-1].associatedTag)) {
                            replaceSubStringInPlace(type, typeStack[typeStack.size()-1].associatedTag + " ", "");  //Remove "struct " from type
                            replaceSubStringInPlace(type, "class ", "");  //Deal with enum class foo {};
                            replaceSubStringInPlace(type, " ", "");
                        }
                    }
                }

                std::string stereotype = (isStereotypableCategory(category) && stereotypeStack.size() != 0 ? stereotypeStack[stereotypeStack.size() - 1] : "");
                if (stereotypeStack.size() != 0) stereotypeStack.pop_back();

                //Remove any prefix String:: from context - for functions
                if (content.find("::") != std::string::npos)
                    content = content.substr(content.find("::")+2, content.length()-1);

                if (usePreviousPosition) {
                    position = previousPosition;
                    usePreviousPosition = false;
                }

                //Output results
                if (outputCSV)
                    *outPtr << identifier(content, category, position, stereotype, srcFileName, srcFileLanguage, type);
                else
                    printReport(*outPtr, identifier(content, category, position, stereotype, srcFileName, srcFileLanguage, type));

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
            }






            else if (isNoDeclLanguage() && isExprCategory(category)) {

                bool isComplexFieldName = false;
                // If complex name, need to verify it is 'self.XYZ' being defined and we are currently in a class
                if (isComplexName && 
                    complexNameCount == 2 && 
                    previousComplexName == "self" &&
                    scopeStack.back().type == "function" &&
                    scopeStack[scopeStack.size()-2].type == "class") {
                        isComplexFieldName = true;
                }
                if (!isComplexName || isComplexFieldName) {
                    scope& currentScope = !isComplexFieldName ? scopeStack.back() : scopeStack[scopeStack.size()-2];
                    if (category == "expr_stmt" || category == "condition") {

                        // Check if the name is currently in the current scope
                        if (currentScope.names.find(content) == currentScope.names.end()) {
                            // Determine category based on scope
                            if (currentScope.type == "global")
                                category = "global";
                            else if (currentScope.type == "function")
                                category = "local";
                            else if (currentScope.type == "class")
                                category = "field";
                            expressionNames.push_back(identifier(content, category, position, "", srcFileName, srcFileLanguage, ""));

                            if (DEBUG) {  //Print identifier and stacks
                                std::cerr << "Identifier: " << content << std::endl;
                                std::cerr << "Category: " << category << std::endl;
                                std::cerr << "Position: " << position << std::endl;
                                std::cerr << "Stereotype: " << "" << std::endl;
                                std::cerr << "Type: " << "" << std::endl;
                                std::cerr << "Element Stack: ";
                                for (int i=elementStack.size()-1; i>=0; --i) { std::cerr << elementStack[i] << " | "; }
                                std::cerr << std::endl;
                                std::cerr << "Type Stack: ";
                                for (int i=typeStack.size()-1; i>=0; --i) { std::cerr << "[" << typeStack[i].type << ", " << typeStack[i].associatedTag << "]"  << " | "; }
                                std::cerr << std::endl;
                                std::cerr << "Scope Stack: " << std::endl;
                                for (int i=scopeStack.size()-1; i>=0; --i) {
                                    std::cerr << "\t" << scopeStack[i].type << " - ";
                                    for(auto name : scopeStack[i].names) { std::cerr << name << ","; }
                                    std::cerr << std::endl;
                                }
                                std::cerr << "------------------------" << std::endl;
                            }
                        }
                    }
                    else if (category == "global" || category == "nonlocal") {
                        // Just need to add to local scope so it isn't counted.
                        currentScope.names.insert(content);
                    }
                    else if (category == "control") {
                        bool isComprehensionControl = elementStack[elementStack.size()-(nameDepth+4)] == "comprehension";
                        if (currentScope.names.find(content) == scopeStack.back().names.end() || isComprehensionControl) {
                            if (!isComprehensionControl)
                                currentScope.names.insert(content);

                            if (isComprehensionControl)
                                category = "local";
                            else if (currentScope.type == "global")
                                category = "global";
                            else if (currentScope.type == "function")
                                category = "local";
                            else if (currentScope.type == "class")
                                category = "field";
                            if (outputCSV)
                                *outPtr << identifier(content, category, position, "", srcFileName, srcFileLanguage, "");
                            else
                                printReport(*outPtr, identifier(content, category, position, "", srcFileName, srcFileLanguage, ""));

                            if (DEBUG) {  //Print identifier and stacks
                                std::cerr << "Identifier: " << content << std::endl;
                                std::cerr << "Category: " << category << std::endl;
                                std::cerr << "Position: " << position << std::endl;
                                std::cerr << "Stereotype: " << "" << std::endl;
                                std::cerr << "Type: " << "" << std::endl;
                                std::cerr << "Element Stack: ";
                                for (int i=elementStack.size()-1; i>=0; --i) { std::cerr << elementStack[i] << " | "; }
                                std::cerr << std::endl;
                                std::cerr << "Type Stack: ";
                                for (int i=typeStack.size()-1; i>=0; --i) { std::cerr << "[" << typeStack[i].type << ", " << typeStack[i].associatedTag << "]"  << " | "; }
                                std::cerr << std::endl;
                                std::cerr << "Scope Stack: " << std::endl;
                                for (int i=scopeStack.size()-1; i>=0; --i) {
                                    std::cerr << "\t" << scopeStack[i].type << " - ";
                                    for(auto name : scopeStack[i].names) { std::cerr << name << ","; }
                                    std::cerr << std::endl;
                                }
                                std::cerr << "------------------------" << std::endl;
                            }
                        }
                    }
                    else if (category == "alias") {
                        std::string alias_category = elementStack[elementStack.size()-(nameDepth+3)];
                        if (currentScope.names.find(content) == currentScope.names.end() || alias_category == "catch") {
                            if (alias_category != "catch")
                                currentScope.names.insert(content);

                            if (alias_category == "import")
                                category = "namespace";
                            else if (alias_category == "catch")
                                category = "local";
                            else if (currentScope.type == "global")
                                category = "global";
                            else if (currentScope.type == "function")
                                category = "local";
                            else if (currentScope.type == "class")
                                category = "field";

                            if (outputCSV)
                                *outPtr << identifier(content, category, position, "", srcFileName, srcFileLanguage, "");
                            else
                                printReport(*outPtr, identifier(content, category, position, "", srcFileName, srcFileLanguage, ""));
                            if (DEBUG) {  //Print identifier and stacks
                                std::cerr << "Identifier: " << content << std::endl;
                                std::cerr << "Category: " << category << std::endl;
                                std::cerr << "Position: " << position << std::endl;
                                std::cerr << "Stereotype: " << "" << std::endl;
                                std::cerr << "Type: " << "" << std::endl;
                                std::cerr << "Element Stack: ";
                                for (int i=elementStack.size()-1; i>=0; --i) { std::cerr << elementStack[i] << " | "; }
                                std::cerr << std::endl;
                                std::cerr << "Type Stack: ";
                                for (int i=typeStack.size()-1; i>=0; --i) { std::cerr << "[" << typeStack[i].type << ", " << typeStack[i].associatedTag << "]"  << " | "; }
                                std::cerr << std::endl;
                                std::cerr << "Scope Stack: " << std::endl;
                                for (int i=scopeStack.size()-1; i>=0; --i) {
                                    std::cerr << "\t" << scopeStack[i].type << " - ";
                                    for(auto name : scopeStack[i].names) { std::cerr << name << ","; }
                                    std::cerr << std::endl;
                                }
                                std::cerr << "------------------------" << std::endl;
                            }
                        }
                    }
                }
            }

            if (isComplexName) {
                previousComplexName = content;
            }

            content = "";
            position = "";

            collectContent = false;
        }




        if (std::string(localname) == "type") {
            typeStack[typeStack.size()-1].gatherContent = false;
        } 
        // Note: struct gather content for typename turns off in endElement at block
        if (typeStack.size() != 0)
            if (typeStack[typeStack.size()-1].associatedTag == localname)
                typeStack.pop_back();

        elementStack.pop_back();

        if (std::string(localname) == "operator" && isNoDeclLanguage()) {
            // If at an = operator in expr_stmt, output and then clear the expressions name list
            if (opContent == "=") {
                if (elementStack[elementStack.size()-2] == "expr_stmt") {
                    for (auto identifier : expressionNames) {
                        scope& currentScope = identifier.getCategory() != "field" ? scopeStack.back() : scopeStack[scopeStack.size()-2];
                        if (currentScope.names.find(identifier.getName()) == currentScope.names.end()) {
                            currentScope.names.insert(identifier.getName());
                            if (outputCSV)
                                *outPtr << identifier;
                            else
                                printReport(*outPtr, identifier);
                        }
                    }
                    expressionNames.clear();
                }
            }
            else if (opContent == ":=") {
                if (elementStack[elementStack.size()-2] == "condition" && expressionNames.size() != 0) {
                    if (outputCSV)
                        *outPtr << expressionNames.back();
                    else
                        printReport(*outPtr, expressionNames.back());
                    expressionNames.clear();
                }
            }
            else if (elementStack[elementStack.size()-2] == "condition") {
                expressionNames.clear();
            }
            collectOpContent = false;
            opContent = "";
        }

        //Address namespace foo = x::y;
        // Push an init on stack after first name.  Then make sure to
        //  pop it off at end of </namespace>
        if (category == "namespace" && !isNoDeclLanguage()) {
            elementStack.push_back("init");  // Deal with namespace foo = x::y;
        }
        if (std::string(localname) == "namespace" && !isNoDeclLanguage()) {
            elementStack.pop_back();  // Deal with namespace foo = x::y;
        }

        // If in a no decl language, need to keep track of scope
        if (isNoDeclLanguage() && (std::string(localname) == "function" ||
                                   std::string(localname) == "lambda"   ||
                                   std::string(localname) == "class")) {
            scopeStack.pop_back();
        }

        if (isNoDeclLanguage() && (std::string(localname) == "expr_stmt" ||
                                   std::string(localname) == "condition")) {
            expressionNames.clear();
        }

        // If in the end of an expr, reset complexNameCount
        if (isNoDeclLanguage() && std::string(localname) == "expr") {
            complexNameCount = 0;
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
     * Overide for desired behaviour.
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
     * Overide for desired behaviour.
     */
    virtual void charactersUnit(const char* ch, int len) {
        /*  Characters may be called multiple times in succession
            in some cases the text may need to be gathered all at once
            before output. Both methods are shown here although the delayed
            output is used.
        */
        if (collectContent) {
            content.append((const char *)ch, len);
        }
        if (collectOpContent) {
            opContent.append((const char *)ch, len);
        }
        for (auto& type : typeStack)
            if (type.gatherContent)
                type.type.append((const char *)ch, len);

    }

    /*
    // Not typically in srcML documents 
    virtual void metaTag(const char* localname, const char* prefix, const char* URI,
                           int num_namespaces, const struct srcsax_namespace * namespaces, int nb_attributes,
                           const struct srcsax_attribute * attributes) {}
    virtual void comment(const char* value) {}
    virtual void cdataBlock(const char* value, int len) {}
    virtual void processingInstruction(const char* target, const char* data) {}
    */

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

    bool isTemplateParameter() const {
        int i=elementStack.size()-1;
        while (i > 0) {
            if (elementStack[i] == "template" || elementStack[i] == "generic_parameter_list") return true;
            --i;
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

    bool isUntypedLanguage() const {
        return srcFileLanguage == "Python"; // Add any future untyped languages
    }

    bool isNoDeclLanguage() const {
        return srcFileLanguage == "Python"; // Add any future languages which have no decls
    }

    bool                     collectContent;       //Flag to collect characters
    std::string              content;              //Content collected
    std::string              position;             //The position of content
    std::string              previousPosition;     //The last gathered position - important for operator functions
    bool                     usePreviousPosition;  //A flag that specifies whether to use the previous position for output
    std::vector<std::string> stereotypeStack;      //Optional stereotype info of funcs/classes
    std::vector<std::string> elementStack;         //Stack of srcML tags
    bool                     collectOpContent;
    std::string              opContent;
    int                      complexNameCount;
    std::string              previousComplexName;
    std::vector<identifier>  expressionNames;      //List of expression names, which can't be output in order
    std::string              srcFileName;          //Current source code file name (vs xml)
    std::string              srcFileLanguage;      //Current source code language
    std::vector<typeInfo>    typeStack;            //Stack of recent types
    std::vector<scope>       scopeStack;           //Stack of scopes, used for Python
    std::ostream*            outPtr;               //Pointer to the output stream
    bool                     outputCSV;            //True is csv, False is report

};

#endif
