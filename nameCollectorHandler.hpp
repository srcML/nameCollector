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
    nameCollectorHandler() : collectContent(false), content(), position() {};
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
            std::cout << "Attributes on UNIT: " << std::endl;
            for (int i=0; i<numAttributes; ++i)
                std::cout << attributes[i].value << std::endl;
        }

        srcFileLanguage = "unknown";
        if (numAttributes >= 1)
            srcFileLanguage = attributes[1].value;

        srcFileName = "unknown";
        if (numAttributes >= 2)
            srcFileName = attributes[2].value;

        elementStack.push_back(localname);
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

        // Top-level Names
        if (back == "name" && std::string(localname) == "name")
            elementStack.push_back("name_2");

        // Sub-names in complex names
        else if (back.find("name_") == 0 && std::string(localname) == "name") {
            int depth = std::stoi(back.substr(5));
            elementStack.push_back("name_" + std::to_string(depth+1));
        }

        // Operators in top-level names
        else if (back == "name" && std::string(localname) == "operator") 
            elementStack.push_back("operator_name_2");

        // Operators in sub-names
        else if (back.find("name_") == 0 && std::string(localname) == "operator") {
            int depth = std::stoi(back.substr(5));
            elementStack.push_back("operator_name_" + std::to_string(depth+1));
        }

        // All other tags
        else {
            elementStack.push_back(localname);
        }


        if (std::string(localname) == "name") {
            collectContent = true;
            for(int i = 0; i < numAttributes; ++i) {
                if (std::string(attributes[i].prefix) == "pos" && std::string(attributes[i].localname) == "start") {
                    position = attributes[i].value;
                    break;
                }
            }
        }

        else if (std::string(localname) == "type") {
            // Check if this is a type ref=prev
            bool isPrevType = false;
            for (int i = 0; i < numAttributes; ++i) {
                if (std::string(attributes[i].localname) == "prev") {
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

        else if (isStereotypableCategory(localname)) {
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
    virtual void endRoot(const char* localname, const char* prefix, const char* URI) {
    }

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
        if ((std::string(localname) == "name") && (content != ""))  {
            std::string category;
            if (elementStack.back() == "name")
                category = elementStack[elementStack.size()-2]; //Normal name
            else {
                int depth = std::stoi(elementStack.back().substr(5));
                category = elementStack[elementStack.size()-(depth+1)];
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
                if (category == "parameter")
                    if (isTemplateParameter()) category = "template-parameter";
                if (category == "decl") { //Need additional checks
                    category = "global";
                    if (isParameter())  category = "parameter";
                    else if (isLocal()) category = "local";
                    else if (isField()) category = "field";
                }
                
                std::string type = (isTypedCategory(category) && typeStack.size() != 0 ? typeStack[typeStack.size()-1].type : "");
                replaceSubStringInPlace(type,",","&#44;");
                replaceSubStringInPlace(type,"\n","");

                std::string stereotype = (isStereotypableCategory(category) && stereotypeStack.size() != 0 ? stereotypeStack[stereotypeStack.size() - 1] : "");
                if (stereotypeStack.size() != 0) stereotypeStack.pop_back();

                identifiers.push_back(identifier(content, category, position, stereotype, srcFileName, srcFileLanguage, type));

                if (DEBUG) {  //For Debugging
                    std::cout << "Identifier: " << content << std::endl;
                    std::cout << "Category: " << category << std::endl;
                    std::cout << "Position: " << position << std::endl;
                    std::cout << "Stereotype: " << stereotype << std::endl;
                    std::cout << "Type: " << type << std::endl;
                    //Print the stack
                    std::cout << "Stack: " ;
                    for (int i=elementStack.size()-1; i>=0; --i) {
                        std::cout << elementStack[i] << " | ";
                    }
                    std::cout << std::endl;
                    std::cout <<  "------------------------" << std::endl;
                }
            }

            content = "";
            position = "";
            
            collectContent = false;
        }

        else if (std::string(localname) == "type") {
            typeStack[typeStack.size()-1].gatherContent = false;
        }

        // If an operator (::) is found in a signifigant name, delete previous name
        else if (std::string(localname) == "operator") {
            if (elementStack.back().find("operator_name_") == 0) {
                int depth = std::stoi(elementStack.back().substr(14));
                if(isUserDefinedIdentifier(elementStack[elementStack.size()-(depth+1)])) {

                    if(DEBUG) {
                        std::cout << "Removing " << identifiers[identifiers.size() - 1] << " from stack" << std::endl;
                        std::cout <<  "------------------------" << std::endl;
                    }

                    identifiers.erase(identifiers.end() - 1);

                    
                }
            }
        }

        else if (typeStack.size() != 0)
            if (typeStack[typeStack.size()-1].associatedTag == localname)
                typeStack.pop_back();

        elementStack.pop_back();
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
    virtual void charactersRoot(const char* ch, int len) {
    }

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

        /*
            Characters may be called multiple times in succession
            in some cases the text may need to be gathered all at once
            before output. Both methods are shown here although the delayed
            output is used.
        */
        if (collectContent) {
            content.append((const char *)ch, len);
        }
        for (auto& type : typeStack)
            if (type.gatherContent)
                type.type.append((const char*)ch, len);

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

    std::vector<identifier> getIdentifiers() const { return identifiers; }

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
            if (elementStack[i] == "template") return true;
            --i;
        }
        return false;
    }

    bool isField() const {
        int i=elementStack.size()-1;
        while (i > 0) {
            if (elementStack[i] == "class" || elementStack[i] == "struct" ||
                elementStack[i] == "union"|| elementStack[i] == "enum")
                return true;
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


    bool                     collectContent;     //Flag to collect characters
    std::string              content;            //Content collected
    std::string              position;           //The position of content
    std::vector<std::string> stereotypeStack;    //Optional stereotype info of funcs/classes
    std::vector<std::string> elementStack;       //Stack of srcML tags
    std::string              srcFileName;        //Current source code file name (vs xml)
    std::string              srcFileLanguage;    //Current source code language
    std::vector<identifier>  identifiers;        //Identifiers found (results)
    std::vector<typeInfo>    typeStack;          //Stack of recent types
};

#endif
