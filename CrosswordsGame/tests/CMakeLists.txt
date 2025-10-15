cmake_minimum_required(VERSION 3.16)

# Add test subdirectories
add_subdirectory(repositories)

# Add the main test executable for this module
add_executable(TestCrosswordsGame main.cpp)

# Link the test executable with GTest, GMock, the module itself, and other dependencies
target_link_libraries(TestCrosswordsGame PRIVATE
    gtest_main
    gmock_main
    CrosswordsGame # Link against the library of the module being tested
    Qt6::Sql
)

# Add the executable to the CTest test suite
add_test(NAME TestCrosswordsGame COMMAND TestCrosswordsGame)

if(ENABLE_COVERAGE)
    add_coverage_target(TestCrosswordsGame)
endif()

