// SPDX-License-Identifier: GPL-3.0-only
/**
 * @file nameCollector.cpp
 *
 * @copyright Copyright (C) 2023 srcML, LLC. (www.srcML.org)
 *
 * This file is part of the nameCollector application.
 */

/**
 *
 * Takes srcML input (with --position) of a file (C++)
 *  Gets a vector<identifier> which contains name, category, and position
 *  of all the user defined identifiers in the file
 *
 *
 * Need to have installed: libxml2 and srcml
 * Need to build and install srcSAX:
 *  In srcSAX folder:
 *    cmake CMakeLists.txt
 *    make
 *    sudo make install
 *
 *  cmake finds/downloads CLI11.hpp
*/

#include <srcSAXController.hpp>
#include <iostream>
#include <stdlib.h>
#include "CLI11.hpp"
#include "identifierName.hpp"
#include "nameCollectorHandler.hpp"

bool           DEBUG = false;                     // Debug flag from CLI option

// Print out coma separated output (CSV)
// Filename, heading, results.
void printCSV(std::ostream& out, const std::vector<identifier>& identifiers, const std::string& fname) {
    out << "FILENAME:, " << fname << ", " << identifiers.size() << std::endl;
    out << "IDENTIFIER" << ", TYPE" << ", POSTION" << std::endl;
    for (unsigned int i = 0; i<identifiers.size(); ++i)
        out << identifiers[i] << std::endl;
}

//Print out simple report
void printReport(std::ostream& out, const std::vector<identifier>& identifiers, const std::string& fname) {
    out << "In file: " << fname
        << " the following " << identifiers.size() << " user defined identifiers occur: " << std::endl;
    for (unsigned int i = 0; i<identifiers.size(); ++i) {
        out << identifiers[i].getName() <<
            " at " << identifiers[i].getPosition() <<
            " is a " << identifiers[i].getCategory() <<std::endl;
    }
}


/**
 * main
 * @param argc number of arguments
 * @param argv the provided arguments (array of C strings)
 * 
 * Invoke srcSAX handler to copy the supplied srcML document and into the given
 * output file.
 */
int main(int argc, char * argv[]) {

    std::string inputFile    = "";
    std::string outputFile   = "";
    std::string outputFormat = "";
    bool        outputCSV    = false; //True is CSV, false is text

    CLI::App app{"nameCollector: Finds all user defined identifier names in a source code file.  "};

    app.add_option("input",        inputFile,    "Name of srcML file of source code with --position option")->required();
    app.add_option("-o, --output", outputFile,   "Name of output file");
    app.add_option("-f, --format", outputFormat, "The output format (text by default): csv, text"); //To support other output options
    app.add_flag  ("-c, --csv",    outputCSV,    "Short for: --format csv");
    app.add_flag  ("-d, --debug",  DEBUG,        "Turn on debug mode (off by default)");

    CLI11_PARSE(app, argc, argv);

    try {
        srcSAXController        control(inputFile.c_str());
        nameCollectorHandler    handler;
        control.parse(&handler);
        //Results
        std::vector<identifier> identifiers = handler.getIdentifiers();
        std::string             srcName     = handler.getsrcFileName();

        //Output format is text by default outputCSV == false
        if (outputFormat == "text") outputCSV = false;
        if (outputFormat == "csv")  outputCSV = true;
        if (outputFile != "") {
            std::ofstream out(outputFile);
            if (!out.is_open()) {
                std::cerr << "Error: can not open file: " << outputFile << " for writing."<< std::endl;
                exit(1);
            }
            if (outputCSV) printCSV(out, identifiers, srcName);
            else           printReport(out, identifiers, srcName);
            out.close();
        } else {
            if (outputCSV) printCSV(std::cout, identifiers, srcName);
            else           printReport(std::cout, identifiers, srcName);
        }
    } catch(std::string& e) {
        std::cerr << e << std::endl;
    }


    return 0;
}
