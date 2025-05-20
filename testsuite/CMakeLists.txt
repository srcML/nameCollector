cmake_minimum_required(VERSION 3.14)
project(nameCollector-testsuite)
enable_testing()



# add test cases
file(GLOB TESTS *.sh)
message(${TESTS})
foreach(TEST IN ITEMS ${TESTS})
    get_filename_component(TEST_NAME ${TEST} NAME)
    message(${TEST_NAME})
    add_test(NAME nameCollector.${TEST_NAME} COMMAND ${TEST})
endforeach()

# copy input files
file(GLOB TESTFILES *.xml)
message("!!!!!!!!!" ./${TESTFILE})
foreach(TESTFILE IN ITEMS ${TESTFILES})
    get_filename_component(TESTFILE_NAME ${TESTFILE} NAME)
    configure_file(${TESTFILE} ${TESTFILE_NAME} COPYONLY)
endforeach()

