cmake_minimum_required(VERSION 3.16)
project(CrosswordsTests LANGUAGES CXX)

# Incluir o módulo de gerenciamento de dependências para garantir que GTest/GMock estejam disponíveis
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
include(Dependencies)

# Adicionar subdiretórios de teste
add_subdirectory(CrosswordsGame)
# add_subdirectory(Native) # Adicionar quando houver testes para Native

# Habilitar a descoberta de testes do CTest
enable_testing()

