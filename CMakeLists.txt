##
#  CMakeLists.txt
#
#  Copyright (C) 2023 srcML, LLC.  (www.srcML.org)
#
#  This file is part of the srcML Infrastructure.
#
#  The srcML Infrastructure is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  The srcML Infrastructure is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with the srcSAX; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

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

find_package(srcML REQUIRED)
find_package(LibXml2 REQUIRED)

link_directories(/usr/local/lib)

add_executable(nameCollector nameCollector.cpp nameCollectorHandler.hpp identifierName.hpp)
target_link_libraries(nameCollector ${LIBSRCSAX} srcML::LibsrcML LibXml2::LibXml2)

# Download the CLI11 parser into directory named "external".
set(CMAKE_EXTERNAL_SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/external) # Creates folder if doesn't exists.
file(DOWNLOAD https://github.com/CLIUtils/CLI11/releases/download/v2.3.2/CLI11.hpp ${CMAKE_EXTERNAL_SOURCE_DIR}/CLI11.hpp) # Name of file is needed since content of file itself are being downloaded.
target_include_directories(nameCollector PRIVATE ${CMAKE_EXTERNAL_SOURCE_DIR})
