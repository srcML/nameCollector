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

#include "identifierName.hpp"
#include "nameCollectorHandler.hpp"
#include <srcSAXController.hpp>
#include <iostream>

/**
 * main
 * @param argc number of arguments
 * @param argv the provided arguments (array of C strings)
 * 
 * Invoke srcSAX handler to copy the supplied srcML document and into the given
 * output file.
 */
int main(int argc, char * argv[]) {
    if(argc < 2) {
        std::cerr << "Useage: nameCollector input_file.xml\n";
        exit(1);
    }

    std::vector<identifier> identifiers;
    srcSAXController     control(argv[1]);
    nameCollectorHandler handler;

    control.parse(&handler);
    identifiers = handler.getIdentifiers();

    std::cout << "In file: " << argv[1]
              << " the following user defined identifiers occur: " << std::endl;
    for (int i = 0; i<identifiers.size(); ++i) {
        std::cout << identifiers[i] << std::endl;
    }

    std::cout << std::endl;
    return 0;
}
