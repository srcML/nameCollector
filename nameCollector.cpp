// SPDX-License-Identifier: GPL-3.0-only
/**
 * @file nameCollector.cpp
 *
 * @copyright Copyright (C) 2023-2026 srcML, LLC. (www.srcML.org)
 *
 * This file is part of the nameCollector application.
 */

/**
 *
 * Takes srcML input (with --position) of a source code file(s)
 * Works for srcML single unit or archives.
 *
 * Need to have installed: libxml2 and srcml
 * Need to build and install srcSAX:
 *  In srcSAX folder:
 *    cmake CMakeLists.txt -B build
 *    cd build
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
    bool        noHeader     = false; //Do not print header in csv
    bool        appendOutput = false;

    std::string   description = "nameCollector";
    description = description + "\n Produces a list of all user defined identifier names in a source code file(s).  Works for C, C++, C#, Java, Python. ";
    description = description + "\n Input: a srcML file/archive - which is one or more source code files. srcML needs --position option.";
    description = description + "\n Output: For each name gives type, syntactic category, and location in file.  CSV or text description output.";
    description = description + "\n Typical USAGE: ./nameCollector -i foo.cpp.xml -o foo.cpp.csv --csv \n";

    CLI::App app{description};
    app.add_option("-i, --input",    inputFile,    "Name of srcML file of source code with --position option");
    app.add_option("-o, --output",   outputFile,   "Name of output file");
    app.add_option("-f, --format",   outputFormat, "The output format (text by default): csv, text"); //To support other output options
    app.add_flag  ("-a, --append",   appendOutput, "Output will be appended to end of file");
    app.add_flag  ("-c, --csv",      outputCSV,    "Output csv with header (same as --format csv)");
    app.add_flag  ("-n, --noheader", noHeader,     "Do not print header in csv output");
    app.add_flag  ("-d, --debug",    DEBUG,        "Turn on debug mode (off by default)");

    CLI11_PARSE(app, argc, argv);

    try {
        //Output format is text by default: outputCSV == false
        if (outputFormat == "text") outputCSV = false;
        if (outputFormat == "csv")  outputCSV = true;

        //Set up output stream
        std::ostream*  out;
        std::ofstream fileOut;
        if (outputFile != "") {
            if (appendOutput)
                fileOut = std::ofstream(outputFile, std::ios::app);
            else
                fileOut = std::ofstream(outputFile);
            if (!fileOut.is_open()) throw std::string("Can not open file: " + outputFile + " for writing.");
            out = &fileOut;
        } else {
            out = &std::cout; //Write to terminal
        }

        nameCollectorHandler handler(out, outputCSV, noHeader); 

        if (inputFile != "") {
            srcSAXController control (inputFile.c_str());
            control.parse(&handler);
        } else {
            std::string input = "";
            std::string line;
            while (std::getline(std::cin, line)) {
                input += line + '\n';
            }
            srcSAXController control (input);
            control.parse(&handler);
        }
        if (outputFile != "") fileOut.close();

    }
    catch (std::string& error) {
        std::cerr << "Error: " << error << std::endl;
    }
    catch (SAXError& error) {
        std::cerr << "Error: " << error.message << " " << error.error_code << std::endl;
    }
    return 0;
}
