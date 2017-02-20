# MODULE:   FilterOnOptions
#
# PROVIDES:
#   filter_on_options(<output_var>
#       [[IF_<option>_[NOT_]ENABLED] file] ...)
#
# Utility function used for conditionally compiling files based on project
# options. That is, for a given set of project options with the format:
#
#   <project name>_ENABLE_<option>
#
# The functionParses a list of arguments (e.g. files) and filters out those
# which do not have an optionally specified option associated with them.
#
# E.g. For the following example CMakeLists.txt
################################################################################
# project(example)
# option(EXAMPLE_ENABLE_MPI "Enabled MPI" ON)
#
# include(FilterOnOptions)
# filter_on_options(FILTERED_SOURCES
#     src/main.cpp
#     IF_MPI_ENABLED     src/mpi_util.cpp
#     IF_MPI_NOT_ENABLED src/normal_util.cpp
#     src/another.cpp)
################################################################################
# The variable FILTERED_SOURCES will either contain
#
#     src/main.cpp src/mpi_util.cpp src/another.cpp
#
# if EXAMPLE_ENABLE_MPI is ON, or
#
#     src/main.cpp src/normal_util.cpp src/another.cpp
#
# if EXAMPLE_ENABLE_MPI is OFF.
#

function(filter_on_options output)
    set(_OPT_PREFIX ${PROJECT_NAME}_ENABLE)
    string(TOUPPER ${_OPT_PREFIX} _OPT_PREFIX_UPPER)

    set(_IGNORE_ARG FALSE)
    foreach(arg ${ARGN})
        if("${arg}" MATCHES "^IF_([^ _\t]+)_(NOT_)?ENABLED$")
            unset(_OPT_NAME)

            # check if an option with a matching name exists
            if(DEFINED ${_OPT_PREFIX}_${CMAKE_MATCH_1})
                set(_OPT_NAME "${_OPT_PREFIX}_${CMAKE_MATCH_1}")
            elseif(DEFINED ${_OPT_PREFIX_UPPER}_${CMAKE_MATCH_1})
                set(_OPT_NAME "${_OPT_PREFIX_UPPER}_${CMAKE_MATCH_1}")
            endif()

            if(DEFINED ${_OPT_NAME})
                # normally we don't ignore the next argument if the given option
                # is on, but if match_count is 2, then ${arg} looks like
                #     IF_OPT_NOT_ENABLED
                # so we need to invert _IGNORE_ARG
                if(CMAKE_MATCH_COUNT EQUAL 2)
                    if (${_OPT_NAME})
                        set(_IGNORE_ARG TRUE)
                    else()
                        set(_IGNORE_ARG FALSE)
                    endif()
                elseif(${_OPT_NAME})
                    set(_IGNORE_ARG FALSE)
                else()
                    set(_IGNORE_ARG TRUE)
                endif()
            else()
                # no matching option found, so this argument is (possibly)
                # an actual source file or something, so pass it through
                list(APPEND _PROCESSED_ARGS "${arg}")
            endif()
        elseif(_IGNORE_ARG)
            # ignore the current argument, aka don't add it to the output list
            # and just reset the ignore flag
            set(_IGNORE_ARG FALSE)
        else()
            # everything is OK, add the argument to the output
            list(APPEND _PROCESSED_ARGS "${arg}")
        endif()
    endforeach()

    set(${output} ${_PROCESSED_ARGS} PARENT_SCOPE)
endfunction()
