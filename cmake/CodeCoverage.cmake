function(add_coverage_target target_name)
    if(NOT ENABLE_COVERAGE)
        return()
    endif()

    find_program(GCOV_PATH gcov)
    find_program(LCOV_PATH lcov)
    find_program(GENHTML_PATH genhtml)

    if(NOT GCOV_PATH)
        message(WARNING "gcov not found, cannot generate code coverage.")
        return()
    endif()
    if(NOT LCOV_PATH)
        message(WARNING "lcov not found, cannot generate code coverage.")
        return()
    endif()
    if(NOT GENHTML_PATH)
        message(WARNING "genhtml not found, cannot generate code coverage.")
        return()
    endif()

    # Define the directory where .gcda and .gcno files will be generated
    set(COVERAGE_DIR ${CMAKE_BINARY_DIR}/coverage)
    file(MAKE_DIRECTORY ${COVERAGE_DIR})

    # Adds a custom target to clean coverage data
    add_custom_target(${target_name}_coverage_clean
        COMMAND ${LCOV_PATH} --directory ${CMAKE_BINARY_DIR} --zerocounters
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMENT "Cleaning gcov counters for ${target_name}"
    )

    # Adds a custom target to run tests and collect coverage data
    add_custom_target(${target_name}_coverage_run
        COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure
        COMMAND ${LCOV_PATH} --capture --directory ${CMAKE_BINARY_DIR} --output-file ${COVERAGE_DIR}/${target_name}.info --ignore-errors mismatch
        COMMAND ${LCOV_PATH} --remove ${COVERAGE_DIR}/${target_name}.info "*/Qt*/*" "*/usr/*" "*moc_*.cpp" "*qrc_*.cpp" "*qml_*.cpp" --output-file ${COVERAGE_DIR}/${target_name}_filtered.info
        COMMAND ${GENHTML_PATH} ${COVERAGE_DIR}/${target_name}_filtered.info --output-directory ${COVERAGE_DIR}/${target_name}_report
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMENT "Running tests and generating code coverage for ${target_name}"
        DEPENDS ${target_name}_coverage_clean
    )

    # Adds a dependency so that the coverage target is executed after the target compilation
    add_dependencies(${target_name}_coverage_run ${target_name})

    message(STATUS "Coverage target ${target_name}_coverage_run created. Report will be in ${COVERAGE_DIR}/${target_name}_report")
endfunction()

