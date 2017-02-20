include(FilterOnOptions)

set(SOURCE_FILES
        include/rkdp/rkdp.hpp
        rkdp/rkdp.cpp)

# main library target
add_library(rkdp ${SOURCE_FILES})

target_include_directories(rkdp PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>)

if(RKDP_ENABLE_INSTALL)
    install(DIRECTORY include/rkdp/ DESTINATION include/rkdp
            FILES_MATCHING PATTERN "*.hpp" PATTERN "*.h")

    install(TARGETS rkdp
            EXPORT rkdp_export
            RUNTIME DESTINATION bin
            LIBRARY DESTINATION lib
            ARCHIVE DESTINATION lib)

    install(EXPORT rkdp_export NAMESPACE Upstream::
            DESTINATION lib/cmake/rkdp)
endif()

if(RKDP_ENABLE_TESTS)
    target_compile_definitions(rkdp INTERFACE
            RKDP_ENABLE_TESTS)

    add_subdirectory(test)
endif()
