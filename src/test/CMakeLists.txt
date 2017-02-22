include(CTest)
enable_testing()

set(test_target ${PROJECT_NAME}_test)

add_executable(${test_target} test.cpp)

set_target_properties(${test_target} PROPERTIES
        CXX_STANDARD 11
        CXX_STANDARD_REQUIRED ON
        CXX_EXTENSIONS OFF
        RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}")

target_link_libraries(${test_target}
        ${PROJECT_NAME}_srclib gtest_main)
