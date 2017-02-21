include(CTest)
enable_testing()

add_executable(rkdp_test
        test.cpp ../include/rkdp/rkdp.hpp)

set_target_properties(rkdp_test PROPERTIES
        CXX_STANDARD 11
        CXX_STANDARD_REQUIRED ON
        CXX_EXTENSIONS OFF
        RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}")

target_link_libraries(rkdp_test
        rkdp_srclib gtest_main)
