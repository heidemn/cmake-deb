cmake_minimum_required(VERSION 3.12.2)

option(BUILD_SHARED_LIBS "Build using shared libraries" ON)

# Option 1: Define version in CMake
#set(ADDNUM_VERSION_MAJOR 0)
#set(ADDNUM_VERSION_MINOR 2)
#set(ADDNUM_VERSION_PATCH 1)
#set(ADDNUM_VERSION ${ADDNUM_VERSION_MAJOR}.${ADDNUM_VERSION_MINOR}.${ADDNUM_VERSION_PATCH})
#file(WRITE version.txt ${ADDNUM_VERSION}\n)
#
# Option 2: Define version in file
#file(READ version.txt ADDNUM_VERSION) ## Does not work if it contains line break
file(STRINGS version.txt ADDNUM_VERSION_LINES) ## Works with line break
list(GET ADDNUM_VERSION_LINES 0 ADDNUM_VERSION)
string(REPLACE "." ";" ADDNUM_VERSION_LIST ${ADDNUM_VERSION})
list(GET ADDNUM_VERSION_LIST 0 ADDNUM_VERSION_MAJOR)
list(GET ADDNUM_VERSION_LIST 1 ADDNUM_VERSION_MINOR)
list(GET ADDNUM_VERSION_LIST 2 ADDNUM_VERSION_PATCH)
message(STATUS "Version=${ADDNUM_VERSION} Major=${ADDNUM_VERSION_MAJOR} Minor=${ADDNUM_VERSION_MINOR} Patch=${ADDNUM_VERSION_PATCH}")

project (addnum VERSION ${ADDNUM_VERSION})

#add_library(addnum STATIC src/add_num.cpp)
#add_library(addnum SHARED src/add_num.cpp)
add_library(addnum src/add_num.cpp) ## Let BUILD_SHARED_LIBS decide which library type to build.

set_target_properties(addnum PROPERTIES
    VERSION ${ADDNUM_VERSION}
    SOVERSION ${ADDNUM_VERSION_MAJOR}
    # May be needed according to https://cmake.org/cmake/help/latest/guide/tutorial/Selecting%20Static%20or%20Shared%20Libraries.html
    # In this case, it worked without.
    POSITION_INDEPENDENT_CODE ${BUILD_SHARED_LIBS}
)

target_include_directories(addnum
    PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/include"
)

add_executable(addnumapp src/main.cpp)
target_link_libraries(addnumapp addnum)

install(TARGETS addnumapp addnum
    #COMPONENT linapp ## defaults to "Unspecified"
    # Don't set these, and let the OS decide.
    #RUNTIME DESTINATION "/usr/local/bin/"
    #LIBRARY DESTINATION "/usr/local/lib/"
    #DESTINATION "/usr/local/bin/"
)

# Ubuntu: "RPM" requires "sudo apt-get install rpm"
SET(CPACK_GENERATOR "DEB" "RPM")
SET(CPACK_DEBIAN_PACKAGE_MAINTAINER "KK") #required
INCLUDE(CPack)
