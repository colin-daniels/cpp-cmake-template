cmake_minimum_required(VERSION 3.2)
project(rkdp CXX)
set(${PROJECT_NAME}_VERSION 0.1)

option(EXAMPLE_ENABLE_TESTS   "Enable tests for project"                ON)
option(EXAMPLE_ENABLE_INSTALL "Add install targets for project headers" ON)

# add custom module path
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/")
include(PreventInSourceBuilds)

# set default build type to release
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING
            "Choose the type of build, options are: \n\
None Debug Release RelWithDebInfo MinSizeRel Coverage."
            FORCE)
endif()

add_subdirectory(libs)
add_subdirectory(src)
