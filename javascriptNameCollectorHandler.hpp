// SPDX-License-Identifier: GPL-3.0-only
/**
 * @file javascriptNameCollectorHandler.hpp
 *
 * @copyright Copyright (C) 2023-2026 srcML, LLC. (www.srcML.org)
 *
 * This file is part of the nameCollector application.
 */


#ifndef INCLUDED_JAVASCRIPT_NAME_COLLECTOR_HANDLER_HPP
#define INCLUDED_JAVASCRIPT_NAME_COLLECTOR_HANDLER_HPP

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

class javascriptNameCollectorHandler : public srcSAXHandler {
public:
    javascriptNameCollectorHandler() : collectContent(false), content(), position(), usePreviousPosition(false), inIndexCount(0), complexNameCount(0), previousComplexName() {};
    javascriptNameCollectorHandler(std::ostream* ptr, bool csv, bool noHeader) : collectContent(false), content(), position(), usePreviousPosition(false), inIndexCount(0), complexNameCount(0), previousComplexName(), outPtr(ptr), outputCSV(csv), printHeader(!noHeader){};
    virtual ~javascriptNameCollectorHandler() {};


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

        if (back == "name" && localName == "name")
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
        } 
        else if(localName == "decl") {
            bool specialDecl = false;
            for (int i = 0; i < numAttributes; ++i) {
                if (std::string(attributes[i].localname) == "type") {
                    elementStack.push_back("decl-"+std::string(attributes[i].value));
                    specialDecl = true;
                    break;
                }
            }
            if (!specialDecl)
                elementStack.push_back("decl");
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
        else if (localName == "index") {
            ++inIndexCount;
            collectContent = false;
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

            if (category.find("decl-") == 0) {
                category = "decl";
            }

            if (isComplexName) {
                ++complexNameCount;
            }

            //Only interested in user defined identifiers
            if (isUserDefinedIdentifier(category)) {
                if (content.find("operator") != std::string::npos && srcFileLanguage == "C++" && category == "function") {
                    usePreviousPosition = true;
                }

                if (category == "parameter") {
                    if (isTemplateParameter()) category = "template-parameter";
                }
                else if (category == "decl") { //Need additional checks
                    category = "global";
                    if (isParameter())  category = "parameter";
                    else {
                        if (isLocal()) category = "local";
                        if (isField()) category = "field";
                    }
                }

                if (usePreviousPosition) {
                    position = previousPosition;
                    usePreviousPosition = false;
                }

                //Output results
                if (outputCSV) {
                    *outPtr << identifier(content, category, position, "", srcFileName, srcFileLanguage, "");
                } else {
                    printReport(*outPtr, identifier(content, category, position, "", srcFileName, srcFileLanguage, ""));
                }

                if (DEBUG) {  //Print identifier and stacks
                    std::cerr << "Identifier: " << content << std::endl;
                    std::cerr << "Category: " << category << std::endl;
                    std::cerr << "Position: " << position << std::endl;
                    std::cerr << "Stereotype: " << "" << std::endl;
                    std::cerr << "Type: " << "" << std::endl;
                    std::cerr << "Element Stack: ";
                    for (int i=elementStack.size()-1; i>=0; --i) { std::cerr << elementStack[i] << " | "; }
                    std::cerr << std::endl;
                    std::cerr << "------------------------" << std::endl;
                }
            }

            if (isComplexName) {
                previousComplexName = content;
            }

            content.clear();
            position = "";

            collectContent = false;
        }

        else if (localName == "index") {
            --inIndexCount;
        }

        if (!elementStack.empty()) elementStack.pop_back();
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

    bool isTemplateParameter() const {
        int i=elementStack.size()-1;
        while (i > 0) {
            if (elementStack[i] == "template" || elementStack[i] == "generic_parameter_list") return true;
            --i;
        }
        if (srcFileLanguage == "Java") {
            if (elementStack.size() >= 5 && elementStack[elementStack.size()-5] == "class" && elementStack[elementStack.size()-4] == "name" && elementStack[elementStack.size()-3] == "parameter_list" && elementStack[elementStack.size()-2] == "parameter")
                return true;
        }
        return false;
    }

    bool isField() const {
        int i = elementStack.size()-1;
        while (i > 0) {
            if (elementStack[i] == "function" || elementStack[i] == "constructor") 
                return false;
            --i;
        }
        return false;
    }

    bool isLocal() const {
        int i = elementStack.size()-1;
        while (i > 0) {
            if (elementStack[i] == "function" || elementStack[i] == "constructor")
                return true;
            --i;
        }

        std::string typeOfDecl = "";
        i = elementStack.size()-1;
        while (i > 0) {
            if (elementStack[i].find("decl-") == 0) {
                typeOfDecl = elementStack[i].substr(5,element_stack[i].size()-5);
                break;
            }
            --i;
        }

        if (typeOfDecl == "var") return false;
        else {
            i = elementStack.size()-1;
            while (i > 0) {
                if (elementStack[i] == "block") {
                    return true;
                }
                --i;
            }
        }

        return false;
    }

    bool                     collectContent;       //Flag to collect characters
    versionedString          content;              //Content collected
    std::string              position;             //The position of content
    std::string              previousPosition;     //The last gathered position - important for operator functions
    bool                     usePreviousPosition;  //A flag that specifies whether to use the previous position for output
    std::string              srcFileName;          //Current source code file name (vs xml)
    std::vector<std::string> elementStack;         //Stack of srcML tags
    int                      inIndexCount;
    int                      complexNameCount;
    std::string              previousComplexName;
    std::string              srcFileLanguage;      //Current source code language
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
    std::vector<diffOperation> diffStack;           //Stack of diff operations

};

#endif