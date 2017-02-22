include(FilterOnOptions)

# mostly install-related variables
set(config_install_dir "lib/cmake/${PROJECT_NAME}")
set(include_install_dir "include")
set(generated_dir "${PROJECT_BINARY_DIR}/generated")

# configuration
set(version_config "${generated_dir}/${PROJECT_NAME}ConfigVersion.cmake")
set(project_config "${generated_dir}/${PROJECT_NAME}Config.cmake")
set(targets_export_name "${PROJECT_NAME}Targets")
set(namespace "${PROJECT_NAME}::")

set(SOURCE_FILES
        include/example_lib/example.hpp
        example_lib/example.cpp)

add_library(${PROJECT_NAME}_common INTERFACE)
target_include_directories(${PROJECT_NAME}_common INTERFACE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)

################################################################################
# library targets, adapted from:                                              ##
#  steveire.wordpress.com/2016/08/09/opt-in-header-only-libraries-with-cmake/ ##
################################################################################

# basic static/shared
add_library(${PROJECT_NAME}_static STATIC ${SOURCE_FILES})
add_library(${PROJECT_NAME}_shared SHARED ${SOURCE_FILES})

################################################################################
# header only target                                                          ##
################################################################################

add_library(${PROJECT_NAME}_headeronly INTERFACE)
target_compile_definitions(${PROJECT_NAME}_headeronly INTERFACE
        EXAMPLE_HEADER_ONLY)

################################################################################
# 'source' interface target                                                    #
################################################################################

add_library(${PROJECT_NAME}_srclib INTERFACE)
foreach(srcfile ${SOURCE_FILES})
    target_sources(${PROJECT_NAME}_srclib INTERFACE
        $<INSTALL_INTERFACE:${include_install_dir}/${PROJECT_NAME}/${srcfile}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${srcfile}>)
endforeach()

# link common to propagate other settings
target_link_libraries(${PROJECT_NAME}_static PUBLIC ${PROJECT_NAME}_common)
target_link_libraries(${PROJECT_NAME}_shared PUBLIC ${PROJECT_NAME}_common)
target_link_libraries(${PROJECT_NAME}_headeronly INTERFACE
        ${PROJECT_NAME}_common)
target_link_libraries(${PROJECT_NAME}_srclib INTERFACE ${PROJECT_NAME}_common)

# installation code, adapted mostly from github.com/forexample/package-example
if(EXAMPLE_ENABLE_INSTALL)
    # Include module with fuction 'write_basic_package_version_file'
    include(CMakePackageConfigHelpers)

    # Configure '<PROJECT-NAME>ConfigVersion.cmake'
    # Note: PROJECT_VERSION is used as a VERSION
    write_basic_package_version_file("${version_config}"
            VERSION ${${PROJECT_NAME}_VERSION}
            COMPATIBILITY SameMajorVersion)


    # Configure '<PROJECT-NAME>Config.cmake'
    # Use variables:
    #   * targets_export_name
    #   * PROJECT_NAME
    configure_package_config_file(
            "${PROJECT_SOURCE_DIR}/cmake/Config.cmake.in"
            "${project_config}"
            INSTALL_DESTINATION "${config_install_dir}")

    install(TARGETS ${PROJECT_NAME}_static
                ${PROJECT_NAME}_shared
                ${PROJECT_NAME}_headeronly
                ${PROJECT_NAME}_srclib
                ${PROJECT_NAME}_common
            EXPORT ${targets_export_name}
            RUNTIME DESTINATION "bin"
            LIBRARY DESTINATION "lib"
            ARCHIVE DESTINATION "lib"
            INCLUDES DESTINATION "${include_install_dir}")

    # copy headers for the normal library targets
    install(DIRECTORY   "include/${PROJECT_NAME}/"
            DESTINATION "${include_install_dir}/${PROJECT_NAME}"
            FILES_MATCHING
                PATTERN "*.h(pp)?")

    # copy sources for the srclib target
    install(DIRECTORY   "example_lib/"
            DESTINATION "${include_install_dir}/${PROJECT_NAME}"
            FILES_MATCHING
                PATTERN "*.[ch](pp)?")

    # copy configs
    install(FILES "${project_config}" "${version_config}"
            DESTINATION "${config_install_dir}")

    install(EXPORT "${targets_export_name}"
            NAMESPACE "${namespace}"
            DESTINATION "${config_install_dir}")

endif()

if(EXAMPLE_ENABLE_TESTS)
    target_compile_definitions(${PROJECT_NAME}_common INTERFACE
            EXAMPLE_ENABLE_TESTS)

    add_subdirectory(test)
endif()
