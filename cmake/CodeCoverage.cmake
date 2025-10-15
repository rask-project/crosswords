function(add_coverage_target target_name)
    if(NOT ENABLE_COVERAGE)
        return()
    endif()

    find_program(GCOV_PATH gcov)
    find_program(GCOVR_PATH gcovr)

    if(NOT GCOV_PATH)
        message(WARNING "gcov not found, cannot generate code coverage.")
        return()
    endif()
    if(NOT GCOVR_PATH)
        message(WARNING "gcovr not found, cannot generate code coverage.")
        return()
    endif()

    # Define the directory where coverage artifacts will be generated
    set(COVERAGE_DIR ${CMAKE_BINARY_DIR}/coverage)
    file(MAKE_DIRECTORY ${COVERAGE_DIR})

    set(GCOVR_COMMON_ARGS
        --gcov-executable
        ${GCOV_PATH}
        --gcov-ignore-errors=no_working_dir_found
        --root
        ${CMAKE_SOURCE_DIR}
        --object-directory
        ${CMAKE_BINARY_DIR}
        --filter=^CrosswordsGame/
        --filter=^Native/
        --exclude=^CrosswordsGame/tests/
        --exclude=^tests/
        --exclude=^main.cpp$
        --exclude=.*moc_.*
        --exclude=.*qrc_.*
        --exclude=.*qml_.*
        --exclude-unreachable-branches
        --exclude-throw-branches
        --sort=uncovered-percent
    )

    # Adds a custom target to clean coverage data
    add_custom_target(${target_name}_coverage_clean
        COMMAND ${CMAKE_COMMAND} -E remove_directory ${COVERAGE_DIR}
        COMMAND ${CMAKE_COMMAND} -E make_directory ${COVERAGE_DIR}
        COMMAND ${GCOVR_PATH} --gcov-executable ${GCOV_PATH} --root ${CMAKE_BINARY_DIR} --delete
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMENT "Cleaning gcov counters for ${target_name}"
    )

    # Adds a custom target to run tests and collect coverage data
    add_custom_target(${target_name}_coverage_run
        COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure
        COMMAND ${GCOVR_PATH} ${GCOVR_COMMON_ARGS}
            --html-details=${COVERAGE_DIR}/index.html
            --lcov -o ${COVERAGE_DIR}/lcov.info
        COMMAND ${GCOVR_PATH} ${GCOVR_COMMON_ARGS}
            --xml-pretty --output ${COVERAGE_DIR}/coverage.xml
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMENT "Running tests and generating code coverage for ${target_name}"
        DEPENDS ${target_name}_coverage_clean
    )

    # Adds a dependency so that the coverage target is executed after the target compilation
    add_dependencies(${target_name}_coverage_run ${target_name})

    message(STATUS "Coverage target ${target_name}_coverage_run created. Reports will be in ${COVERAGE_DIR}")
endfunction()

