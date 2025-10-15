add_executable(TestCrosswordsRepository TestCrosswordsRepository.cpp main.cpp)

target_link_libraries(TestCrosswordsRepository PRIVATE
    gtest_main
    gmock_main
    CrosswordsGame # Link against the library of the module being tested
    Qt6::Sql
)

# Include directories for mocks and the code to be tested
target_include_directories(TestCrosswordsRepository PRIVATE
    ${CMAKE_SOURCE_DIR} # Allow includes like "CrosswordsGame/..."
)

add_test(NAME TestCrosswordsRepository COMMAND TestCrosswordsRepository)

