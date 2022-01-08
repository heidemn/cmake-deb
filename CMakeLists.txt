cmake_minimum_required(VERSION 3.12.2)

option(BUILD_SHARED_LIBS "Build using shared libraries" ON)

set(ADDNUM_VERSION_MAJOR 0)
set(ADDNUM_VERSION_MINOR 2)
set(ADDNUM_VERSION_PATCH 0)
set(ADDNUM_VERSION ${ADDNUM_VERSION_MAJOR}.${ADDNUM_VERSION_MINOR}.${ADDNUM_VERSION_PATCH})

project (addnum VERSION ${ADDNUM_VERSION})

#add_library(addnum STATIC src/add_num.cpp)
#add_library(addnum SHARED src/add_num.cpp)
add_library(addnum src/add_num.cpp)

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
    #RUNTIME DESTINATION "/usr/local/bin/"
    #LIBRARY DESTINATION "/usr/local/lib/"
    #DESTINATION "/usr/local/bin/"
)

SET(CPACK_GENERATOR "DEB")
SET(CPACK_DEBIAN_PACKAGE_MAINTAINER "KK") #required
INCLUDE(CPack)
