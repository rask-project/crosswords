cmake_minimum_required(VERSION 3.16)

# Include dependency management module
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(Dependencies)
include(CodeCoverage)

# Options for building tests and enabling code coverage
option(BUILD_TESTING "Build the tests" ON)
option(ENABLE_COVERAGE "Enable code coverage with GCOV" OFF)

# Download and configure GTest and GMock if tests are enabled
if(BUILD_TESTING)
    add_dep(
        NAME gtest
        URL https://github.com/google/googletest.git
        TAG release-1.11.0 # Use a specific tag for stability
    )
    enable_testing()
endif()

# Configure GCOV flags if code coverage is enabled
if(ENABLE_COVERAGE)
    message(STATUS "Code coverage enabled with GCOV")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fprofile-arcs -ftest-coverage")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fprofile-arcs -ftest-coverage")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -fprofile-arcs -ftest-coverage")
endif()

project(Crosswords
    VERSION 1.0.0
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_AUTOMOC ON)

find_package(Qt6 6.8 REQUIRED COMPONENTS Quick Sql)

qt_standard_project_setup(REQUIRES 6.8)

add_subdirectory(CrosswordsGame)
add_subdirectory(Native)

if(ENABLE_COVERAGE)
    add_coverage_target(${PROJECT_NAME})
endif()

# add_subdirectory(tests) # Tests will be included per module now

qt_add_executable(${PROJECT_NAME}
    main.cpp
)

add_subdirectory(resources/icons)

set_source_files_properties(resources/qtquickcontrols2.conf PROPERTIES QT_RESOURCE_ALIAS qtquickcontrols2.conf)

qt6_add_resources(${PROJECT_NAME} "resources"
    PREFIX "/"
    FILES
        resources/qtquickcontrols2.conf
        resources/logo.png
)

qt_add_qml_module(${PROJECT_NAME}
    URI Game
    VERSION 1.0
    QML_FILES
        Main.qml

        controls/ButtonAction.qml
        controls/CrosswordsItemDelegate.qml
        controls/HeaderBar.qml
        controls/Page.qml
        controls/ScrollablePage.qml
        controls/TextAlert.qml

        pages/CrosswordsGamePage.qml
        pages/CrosswordsListPage.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
# set_target_properties(${PROJECT_NAME} PROPERTIES
#     MACOSX_BUNDLE_GUI_IDENTIFIER com.rask-project.BibleGame
#     MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
#     MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
#     MACOSX_BUNDLE TRUE
#     WIN32_EXECUTABLE TRUE
# )

set_property(
  TARGET ${PROJECT_NAME}
  APPEND
  PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android)

target_link_libraries(${PROJECT_NAME}
    PRIVATE
        Qt6::Quick
        Qt6::Sql
)

include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

