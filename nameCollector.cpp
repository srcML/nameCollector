/**
 * @file nameCollector.cpp
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
*/

#include <srcSAXController.hpp>
#include <iostream>
#include "CLI11.hpp"
#include "identifierName.hpp"
#include "nameCollectorHandler.hpp"

bool           DEBUG = false;                     // Debug flag from CLI option

void printCSV(std::ostream& out, std::vector<identifier>& identifiers, const std::string& inputFile) {
    out << inputFile << ", ," << std::endl;
    out << "NAME" << ", TYPE" << ", POSTION" << std::endl;
    for (unsigned int i = 0; i<identifiers.size(); ++i)
        out << identifiers[i] << std::endl;
}

void printReport(std::ostream& out, std::vector<identifier>& identifiers, const std::string& inputFile) {
    out << "In file: " << inputFile
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

    std::string inputFile  = "";
    std::string outputFile = "";
    bool outputCSV      = false; //True is CSV output, false is plain text

    CLI::App app{"nameCollector: Finds all user defined identifier names"};

    app.add_option("input-file", inputFile,  "Filename of srcML file with --position option")->required();
    app.add_option("-o,--output-file", outputFile, "Filename of output");
    app.add_flag  ("-c,--csv",  outputCSV, "CSV output (default is plain text report)");
    app.add_flag  ("-d,--debug",  DEBUG, "Turn on debug mode (off by default)");

    CLI11_PARSE(app, argc, argv);

    srcSAXController        control(inputFile.c_str());
    nameCollectorHandler    handler;
    std::vector<identifier> identifiers; //Results

    control.parse(&handler);
    identifiers = handler.getIdentifiers();

    if (outputCSV) {
        if (outputFile == "")
            printCSV(std::cout, identifiers, inputFile);
        else {
            std::ofstream out(outputFile);
            printCSV(out, identifiers, inputFile);
            out.close();
        }

    } else {
        if (outputFile == "")
            printReport(std::cout, identifiers, inputFile);
        else {
            std::ofstream out(outputFile);
            printReport(out, identifiers, inputFile);
            out.close();
        }
    }
    
    return 0;
}
