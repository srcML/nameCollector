## SPDX-License-Identifier: GPL-3.0-only
##
#  CMakeLists.txt
#
#  Copyright (C) 2023-2026 srcML, LLC. (www.srcML.org)
#
#  This file is part of the nameCollector application.
#

cmake_minimum_required(VERSION 3.14)
project(nameCollector)

enable_testing()

# C++17 standard (Not enforced).
set(CMAKE_CXX_STANDARD 17)

# Turn on compiler warnings.
add_compile_options(
    $<$<CXX_COMPILER_ID:GNU,Clang,AppleClang>:-Wall> # Adds "-Wall" to the options if the compiler is either GNU, Clang, or AppleClang
    $<$<CXX_COMPILER_ID:GNU,Clang,AppleClang>:-Wextra>
    $<$<CXX_COMPILER_ID:GNU,Clang,AppleClang>:-pedantic>
    $<$<CXX_COMPILER_ID:MSVC>:/Wall>
)

# project options

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

include_directories(/usr/local/include/srcsax)

find_library(LIBSRCSAX NAMES libsrcsax.a srcsax PATHS /usr/local/lib REQUIRED)

find_package(LibXml2 REQUIRED)

link_directories(/usr/local/lib)

add_executable(nameCollector nameCollector.cpp nameCollectorHandler.hpp identifierName.hpp)
target_link_libraries(nameCollector ${LIBSRCSAX} LibXml2::LibXml2)

# Download the CLI11 parser into directory named "external".
set(CMAKE_EXTERNAL_SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/external) # Creates folder if doesn't exists.
file(DOWNLOAD https://github.com/CLIUtils/CLI11/releases/download/v2.3.2/CLI11.hpp ${CMAKE_EXTERNAL_SOURCE_DIR}/CLI11.hpp) # Name of file is needed since content of file itself are being downloaded.
target_include_directories(nameCollector PRIVATE ${CMAKE_EXTERNAL_SOURCE_DIR})


add_subdirectory(testsuite)
