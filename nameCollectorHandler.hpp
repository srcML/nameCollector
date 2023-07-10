/**
 * @file nameColloctorHandler.hpp
 * Modified by Maletic on July 2023.

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
 * This handler collect all the names in a single file (in srcML).
 * It creates a stack so the syntactic category of the name can be
 *  determined.
 *  Constructs a vector of (name, syntactic type, pos)
 *  ("foo", "function", "10:6") A function foo at line 10, column 6
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

        if (elementStack.back() == "name")
            elementStack.push_back("name2");
        else
            elementStack.push_back(localname);

        if (std::string(localname) == "name") {
            collectContent = true;
            if (numAttributes >= 1) {
                position = attributes[0].value;
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
            if (elementStack.back() == "name2")
                category = elementStack[elementStack.size()-3];// <name> <name>
            else
                category = elementStack[elementStack.size()-2]; //Normal name

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
                identifiers.push_back(identifier(content, category, position));

                if (DEBUG) {  //For Debugging
                    std::cout << "Identifier: " << content << std::endl;
                    std::cout << "Category: " << category << std::endl;
                    std::cout << "Position: " << position << std::endl;
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


    bool                     collectContent;   //Flag to collect characters
    std::string              content;          //Content collected
    std::string              position;         //The position of content
    std::vector<std::string> elementStack;     //Stack of srcML tags
    std::vector<identifier>  identifiers;      //Identifiers found (results)
};

#endif
