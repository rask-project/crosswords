cmake_minimum_required(VERSION 3.24)

project(CrosswordsGame
    VERSION 1.0.0
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_AUTOMOC ON)

find_package(Qt6 6.8 REQUIRED COMPONENTS Quick Sql)

qt_standard_project_setup(REQUIRES 6.8)

# To include QML_ELEMENT
include_directories(./models)
include_directories(./viewmodels)

set_source_files_properties(qml/Colors.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(${PROJECT_NAME}
    URI ${PROJECT_NAME}
    VERSION ${PROJECT_VERSION}
    QML_FILES
        qml/CrosswordsGame.qml
        qml/Letter.qml
        qml/QuestionIndicator.qml
        qml/QuestionTip.qml
        qml/QuestionsArea.qml
        qml/ShowVerseButton.qml

    SOURCES
        data/UnitOfWork.h data/UnitOfWork.cpp
        repositories/CrosswordsRepository.h repositories/CrosswordsRepository.cpp
        repositories/CrosswordsResponseRepository.h repositories/CrosswordsResponseRepository.cpp
        repositories/ICrosswordsRepository.h
        utils/ResourceUtils.h utils/ResourceUtils.cpp
        viewmodels/Crosswords.h viewmodels/Crosswords.cpp
        viewmodels/CrosswordsModel.h viewmodels/CrosswordsModel.cpp
        viewmodels/CrosswordsResponse.h viewmodels/CrosswordsResponse.cpp
)

qt_add_resources(${PROJECT_NAME} sql
    PREFIX "/"
    FILES
        resources/sql/schema.sql
        resources/sql/crosswords.sql
        resources/sql/insert_crosswords_response.sql
        resources/sql/delete_crosswords_responses.sql
        resources/sql/select_all_crosswords.sql
        resources/sql/select_crosswords_responses.sql
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE
        Qt6::Core
        Qt6::Quick
        Qt6::Sql
)

install(TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# qt_generate_deploy_qml_app_script(
#     TARGET ${PROJECT_NAME}
#     OUTPUT_SCRIPT deploy_script
#     MACOS_BUNDLE_POST_BUILD
#     NO_UNSUPPORTED_PLATFORM_ERROR
#     DEPLOY_USER_QML_MODULES_ON_UNSUPPORTED_PLATFORM
# )
# install(SCRIPT ${deploy_script})
