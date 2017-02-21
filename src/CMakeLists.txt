include(FilterOnOptions)

set(SOURCE_FILES
        include/rkdp/rkdp.hpp
        rkdp/rkdp.cpp)

add_library(rkdp_common INTERFACE)
target_include_directories(rkdp_common INTERFACE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)

################################################################################
# library targets, adapted from:                                              ##
#  steveire.wordpress.com/2016/08/09/opt-in-header-only-libraries-with-cmake/ ##
################################################################################

# basic static/shared
add_library(rkdp_static STATIC ${SOURCE_FILES})
add_library(rkdp_shared SHARED ${SOURCE_FILES})

################################################################################
# header only target                                                          ##
################################################################################

add_library(rkdp_headeronly INTERFACE)
target_compile_definitions(rkdp_headeronly INTERFACE
        RKDP_HEADER_ONLY)

################################################################################
# 'source' interface target                                                    #
################################################################################

add_library(rkdp_srclib INTERFACE)
foreach(srcfile ${SOURCE_FILES})
    target_sources(rkdp_srclib INTERFACE
            $<INSTALL_INTERFACE:include/rkdp/${srcfile}>
            $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${srcfile}>)
endforeach()

# link common to propagate other settings
target_link_libraries(rkdp_static PUBLIC rkdp_common)
target_link_libraries(rkdp_shared PUBLIC rkdp_common)
target_link_libraries(rkdp_headeronly INTERFACE rkdp_common)
target_link_libraries(rkdp_srclib INTERFACE rkdp_common)

if(RKDP_ENABLE_INSTALL)
    install(DIRECTORY   include/rkdp/
            DESTINATION include/rkdp
            FILES_MATCHING
                PATTERN "*.h(pp)?")

    install(DIRECTORY   rkdp/
            DESTINATION include/rkdp
            FILES_MATCHING
                PATTERN "*.[ch](pp)?")

    install(TARGETS rkdp_static
                rkdp_shared
                rkdp_headeronly
                rkdp_srclib
                rkdp_common
            EXPORT rkdp_targets
            RUNTIME DESTINATION bin
            LIBRARY DESTINATION lib
            ARCHIVE DESTINATION lib
            INCLUDES DESTINATION include)

    install(EXPORT rkdp_targets NAMESPACE Upstream::
            DESTINATION lib/cmake/rkdp)
endif()

if(RKDP_ENABLE_TESTS)
    target_compile_definitions(rkdp_common INTERFACE
            RKDP_ENABLE_TESTS)

    add_subdirectory(test)
endif()
