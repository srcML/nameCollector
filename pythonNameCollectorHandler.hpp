// SPDX-License-Identifier: GPL-3.0-only
/**
 * @file pythonNameCollectorHandler.hpp
 *
 * @copyright Copyright (C) 2023-2026 srcML, LLC. (www.srcML.org)
 *
 * This file is part of the nameCollector application.
 */


#ifndef INCLUDED_PYTHON_NAME_COLLECTOR_HANDLER_HPP
#define INCLUDED_PYTHON_NAME_COLLECTOR_HANDLER_HPP

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

struct scope {
    std::string type;
    std::unordered_set<std::string> names;
};


class pythonNameCollectorHandler : public srcSAXHandler {
public:
    pythonNameCollectorHandler() : collectContent(false), content(), position(), collectOpContent(false), opContent(), inIndexCount(0), complexNameCount(0), previousComplexName() {};
    pythonNameCollectorHandler(std::ostream* ptr, bool csv, bool noHeader) : collectContent(false), content(), position(), collectOpContent(false), opContent(), inIndexCount(0), complexNameCount(0), previousComplexName(), outPtr(ptr), outputCSV(csv), printHeader(!noHeader){};
    virtual ~pythonNameCollectorHandler() {};


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

        scope globalScope;
        globalScope.type = "global";
        scopeStack.push_back(globalScope);

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

        const std::string localName = localname;

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
        } else { // All other tags
            elementStack.push_back(localName);
        }

        if (localName == "name" && inIndexCount == 0) {
            collectContent = true;

            // Get position info if it exists
            for (int i = 0; i < numAttributes; ++i) {
                if (std::string(attributes[i].prefix) == "pos" && std::string(attributes[i].localname) == "start") {
                    position = attributes[i].value;
                    break;
                }
            }
        } 
        else if (localName == "from" && elementStack.size() >= 2 && elementStack[elementStack.size()-2] == "import") {
            elementStack[elementStack.size()-2] = "from-import";
        } 

        if (std::string(localname) == "index") {
            ++inIndexCount;
            collectContent = false;
        }

        if (localName == "operator") {
            collectOpContent = true;
        }

        // If in a no decl language, need to keep track of scope
        if (localName == "function" || localName == "lambda") {
            scope functionScope;
            functionScope.type = "function";
            scopeStack.push_back(functionScope);
        }
        else if (localName == "class") {
            scope classScope;
            classScope.type = "class";
            scopeStack.push_back(classScope);
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
        if (!scopeStack.empty())      scopeStack.clear();

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

        const std::string localName = localname;

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

            // If in a no decl language AND category is expr, go a level higher
            if (category == "expr") {
                std::string expr_category = elementStack.size() >= (nameDepth + 2) ? elementStack[elementStack.size()-(nameDepth+2)] : "";
                if (expr_category == "expr_stmt" ||
                    expr_category == "condition" ||
                    expr_category == "alias"     ||
                    expr_category == "control") {
                    category = expr_category;
                }
                else if (expr_category == "tuple" ||
                         expr_category == "array") {
                    nameDepth += 2;
                    expr_category = elementStack.size() >= (nameDepth + 2) ? elementStack[elementStack.size()-(nameDepth+2)] : "";
                    if (expr_category == "expr_stmt" ||
                        expr_category == "control") {
                        category = expr_category;
                    }
                }
            }

            //Only interested in user defined identifiers
            if (isUserDefinedIdentifier(category)) {

                if (category == "parameter") {
                    scopeStack.back().names.insert(content);
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

                std::string stereotype = "";

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
                    std::cerr << "------------------------" << std::endl;
                }
            } else if (isExprCategory(category)) {
                bool isComplexFieldName = false;
                // If complex name, need to verify it is 'self.XYZ' being defined and we are currently in a class
                if (isComplexName && 
                    complexNameCount == 2 && 
                    previousComplexName == "self" &&
                    scopeStack.size() >= 2 &&
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
                        bool isComprehensionControl = elementStack.size() >= (nameDepth + 4) ? elementStack[elementStack.size()-(nameDepth+4)] == "comprehension" : false;
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
                        std::string alias_category = elementStack.size() >= (nameDepth + 3) ? elementStack[elementStack.size()-(nameDepth+3)] : "";
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

            content.clear();
            position = "";

            collectContent = false;
        }
        

        if (localName == "index") {
            --inIndexCount;
        }

        if (!elementStack.empty()) elementStack.pop_back();

        if (localName == "operator") {
            // If at an = operator in expr_stmt, output and then clear the expressions name list
            if (opContent == "=") {
                if (elementStack.size() >= 2 && elementStack[elementStack.size()-2] == "expr_stmt") {
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
                if (elementStack.size() >= 2 && elementStack[elementStack.size()-2] == "condition" && expressionNames.size() != 0) {
                    if (outputCSV)
                        *outPtr << expressionNames.back();
                    else
                        printReport(*outPtr, expressionNames.back());
                    expressionNames.clear();
                }
            }
            else if (elementStack.size() >= 2 && elementStack[elementStack.size()-2] == "condition") {
                expressionNames.clear();
            }
            collectOpContent = false;
            opContent = "";
        }

        // If in a no decl language, need to keep track of scope
        if (localName == "function" || localName == "lambda" || localName == "class") {
            if (!scopeStack.empty()) scopeStack.pop_back();
        }

        if (localName == "expr_stmt" || localName == "condition") {
            expressionNames.clear();
        }

        // If in the end of an expr, reset complexNameCount
        if (localName == "expr") {
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
        if (collectOpContent) {
            opContent.append((const char *)ch, len);
        }
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
            if (elementStack[i] == "generic_parameter_list") return true;
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

    bool                     collectContent;       //Flag to collect characters
    versionedString          content;              //Content collected
    std::string              position;             //The position of content
    std::vector<std::string> elementStack;         //Stack of srcML tags
    bool                     collectOpContent;
    std::string              opContent;
    int                      inIndexCount;
    int                      complexNameCount;
    std::string              previousComplexName;
    std::vector<identifier>  expressionNames;      //List of expression names, which can't be output in order
    std::string              srcFileName;          //Current source code file name (vs xml)
    std::string              srcFileLanguage;      //Current source code language
    std::vector<scope>       scopeStack;           //Stack of scopes, used for Python
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