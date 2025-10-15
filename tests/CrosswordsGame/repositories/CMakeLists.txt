add_executable(TestCrosswordsRepository TestCrosswordsRepository.cpp)
target_link_libraries(TestCrosswordsRepository PRIVATE
    gtest_main
    gmock_main
    CrosswordsGame
    Qt6::Sql
)

# Incluir diretórios para os mocks e o código a ser testado
target_include_directories(TestCrosswordsRepository PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/../../CrosswordsGame
)

add_test(NAME TestCrosswordsRepository COMMAND TestCrosswordsRepository)

