// SPDX-License-Identifier: GPL-3.0-only
/**
 * @file nameCollectorHandler.hpp
 *
 * @copyright Copyright (C) 2023-2026 srcML, LLC. (www.srcML.org)
 *
 * This file is part of the nameCollector application.
 */

/**
 *
 *  Collects all user defined names in a given C, C++, C#, Java file
 *
 */

#ifndef INCLUDED_NAME_COLLECTOR_HANDLER_HPP
#define INCLUDED_NAME_COLLECTOR_HANDLER_HPP

#include <libxml/xmlwriter.h>
#include <srcSAXHandler.hpp>

#ifndef NAME_COLLECTOR_CPP_CALLBACK_ADAPTER
#define NAME_COLLECTOR_CPP_CALLBACK_ADAPTER
#include <cppCallbackAdapter.hpp>
#endif

#include <iostream>
#include <string>

#include "cFamilyNameCollectorHandler.hpp"
#include "pythonNameCollectorHandler.hpp"
#include "javascriptNameCollectorHandler.hpp"

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
    nameCollectorHandler() {
        cFamilyHandler = new cFamilyNameCollectorHandler();
        pythonHandler = new pythonNameCollectorHandler();
        javascriptHandler = new javascriptNameCollectorHandler();
    };
    nameCollectorHandler(std::ostream* ptr, bool csv, bool noHeader) : outPtr(ptr), outputCSV(csv), printHeader(!noHeader) {
        cFamilyHandler = new cFamilyNameCollectorHandler(ptr, csv, noHeader);
        pythonHandler = new pythonNameCollectorHandler(ptr, csv, noHeader);
        javascriptHandler = new javascriptNameCollectorHandler(ptr, csv, noHeader);
    };
    ~nameCollectorHandler() {
        delete cFamilyHandler;
        delete pythonHandler;
        delete javascriptHandler;
    };

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
    virtual void startDocument() {
    }

    /**
     * endDocument
     *
     * SAX handler function for end of document.
     * Write the end of xml document.
     *
     * Override for desired behaviour.
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
     * Override for desired behaviour.
     */
    virtual void startRoot(const char* localname, const char* prefix, const char* URI,
                           int numNamespaces, const struct srcsax_namespace * namespaces, int numAttributes,
                           const struct srcsax_attribute * attributes) {

        cFamilyHandler->set_context(this->context);
        pythonHandler->set_context(this->context);
        javascriptHandler->set_context(this->context);

        //Check if srcml --position used to generate input
        bool positionNotUsed = true;
        for (int i=0; i<numNamespaces; ++i)
            if (std::string(namespaces[i].uri) == "http://www.srcML.org/srcML/position") positionNotUsed = false;
        if (positionNotUsed) std::cerr << "WARNING: srcml --position NOT used to generate input file." << std::endl;

        if (outputCSV && printHeader) { //Print header once for csv
            *outPtr << "Name,Type,Category,File,Position,Language,Stereotype" << std::endl;
        }

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
     * Override for desired behaviour.
     */
    virtual void startUnit(const char* localname, const char* prefix, const char* URI,
                           int numNamespaces, const struct srcsax_namespace * namespaces, int numAttributes,
                           const struct srcsax_attribute * attributes) {

        if (DEBUG) {  //Print out attributes on <unit>
            std::cerr << "Attributes on UNIT: " << std::endl;
            for (int i=0; i<numAttributes; ++i)
                std::cerr << attributes[i].value << std::endl;
            std::cerr << "Namespaces on UNIT: " << std::endl;
            for (int i=0; i<numNamespaces; ++i)
                std::cerr << namespaces[i].uri << std::endl;
        }

        

        std::string srcFileLanguage = "unknown";
        if (numAttributes >= 2)
            srcFileLanguage = attributes[1].value;

        cppCallbackAdapter* adapter = (cppCallbackAdapter*)(this->context->data);
        if (srcFileLanguage == "C" || srcFileLanguage == "C++" || srcFileLanguage == "C#" || srcFileLanguage == "Java") {
            adapter->push_handler(cFamilyHandler);
            adapter->get_handler()->startUnit(localname, prefix, URI, numNamespaces, namespaces, numAttributes, attributes);
        }
        else if (srcFileLanguage == "Python") { 
            adapter->push_handler(pythonHandler);
            adapter->get_handler()->startUnit(localname, prefix, URI, numNamespaces, namespaces, numAttributes, attributes);
        }
        else if (srcFileLanguage == "JavaScript") {
            adapter->push_handler(javascriptHandler);
            adapter->get_handler()->startUnit(localname, prefix, URI, numNamespaces, namespaces, numAttributes, attributes);
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
     * Override for desired behaviour.
     */
    virtual void startElement(const char* localname, const char* prefix, const char* URI,
                              int numNamespaces, const struct srcsax_namespace * namespaces,
                              int numAttributes, const struct srcsax_attribute * attributes) { }

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
    virtual void endUnit(const char* localname, const char* prefix, const char* URI) { }

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
    virtual void endElement(const char* localname, const char* prefix, const char* URI) { }

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
    virtual void charactersUnit(const char* ch, int len) { }

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
    // Language handlers
    cFamilyNameCollectorHandler* cFamilyHandler;
    pythonNameCollectorHandler* pythonHandler;
    javascriptNameCollectorHandler* javascriptHandler;

    std::ostream*            outPtr;               //Pointer to the output stream
    bool                     outputCSV;            //True is csv, False is report
    bool                     printHeader;          //print csv column header
};

#endif
