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
 * Takes srcML input (with --position) of a source code file(s)
 *  Gets a vector<identifier> which contains name, category, and position
 *  of all the user defined identifiers in the file
 *
 * Works for srcML single unit or archives.
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
#include <fstream>
#include "CLI11.hpp"
#include "identifierName.hpp"
#include "nameCollectorHandler.hpp"

bool           DEBUG = false;                     // Debug flag from CLI option

// Print out coma separated output (CSV) - no header
// identifier, type, category, filename, position
void printCSV(std::ostream& out, const std::vector<identifier>& identifiers) {
    //out << "IDENTIFIER" << ", TYPE" << ", CATEGORY" << ", FILENAME" << ", POSITION" << ", LANGUAGE" << std::endl;
    for (unsigned int i = 0; i < identifiers.size(); ++i)
        out << identifiers[i] << std::endl;
}

//Print out simple report
void printReport(std::ostream& out, const std::vector<identifier>& identifiers) {
    out << "The following " << identifiers.size() << " user defined identifiers occur: " << std::endl;
    for (unsigned int i = 0; i<identifiers.size(); ++i) {
        out << identifiers[i].getName()
            << " is a " << identifiers[i].getType()
            << (identifiers[i].getType() != "" ? " " : "") << identifiers[i].getCategory()
            << " in " << identifiers[i].getLanguage() << " file: " << identifiers[i].getFilename()
            << (identifiers[i].getPosition() != "" ? " at " : "") <<  identifiers[i].getPosition()
            << std::endl;
    }
}

/**
 * main
 * @param argc number of arguments
 * @param argv the provided arguments (array of C strings)
 *
 */
int main(int argc, char * argv[]) {

    std::string inputFile    = "";
    std::string outputFile   = "";
    std::string outputFormat = "";
    bool        outputCSV    = false; //True is CSV, false is text
    bool        appendOutput = false;

    CLI::App app{"nameCollector: Finds all user defined identifier names in a source code file.  "};

    app.add_option("-i, --input",  inputFile,    "Name of srcML file of source code with --position option");
    app.add_option("-o, --output", outputFile,   "Name of output file");
    app.add_option("-f, --format", outputFormat, "The output format (text by default): csv, text"); //To support other output options
    app.add_flag  ("-a, --append", appendOutput, "Output will be appended to end of file");
    app.add_flag  ("-c, --csv",    outputCSV,    "Short for: --format csv");
    app.add_flag  ("-d, --debug",  DEBUG,        "Turn on debug mode (off by default)");

    CLI11_PARSE(app, argc, argv);

    try {

        nameCollectorHandler    handler;

        // srcSAXController        control(inputFile.c_str());
        if (inputFile != "") {
            srcSAXController control (inputFile.c_str());
            control.parse(&handler);
        }
        else {
            std::string input = "";
            std::string line;
            while (std::getline(std::cin, line)) {
                input += line + '\n';
            }
            srcSAXController control (input);
            control.parse(&handler);
        }

        //Results
        std::vector<identifier> identifiers = handler.getIdentifiers();

        //Output format is text by default: outputCSV == false
        if (outputFormat == "text") outputCSV = false;
        if (outputFormat == "csv")  outputCSV = true;
        if (outputFile != "") {
            std::ofstream out;
            if (appendOutput) out.open(outputFile, std::ios::app);
            else              out.open(outputFile);
            if (!out.is_open())
                throw std::string("Can not open file: " + outputFile + " for writing.");
            if (outputCSV) printCSV(out, identifiers);
            else           printReport(out, identifiers);
            out.close();
        } else {
            if (outputCSV) printCSV(std::cout, identifiers);
            else           printReport(std::cout, identifiers);
        }
    }
    catch (std::string& error) {
        std::cerr << "Error: " << error << std::endl;
    }
    catch (SAXError& error) {
        std::cerr << "Error: " << error.message << " " << error.error_code << std::endl;
    }

    return 0;
}
