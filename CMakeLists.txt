cmake_minimum_required(VERSION 3.16)

project(SCADA VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.8 REQUIRED COMPONENTS Quick QuickControls2 Qml Charts Graphs Core Gui)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appSCADA
    main.cpp
)

qt_add_qml_module(appSCADA
    URI SCADA
    VERSION 1.0
    QML_FILES
        Main.qml
        SOURCES slmp.h slmp.cpp
        QML_FILES Gauge.qml
        RESOURCES Resources.qrc
        QML_FILES CustomDial.qml
        QML_FILES NumericalDisplay.qml
        QML_FILES Speed.qml SpeedNeedle.qml
        SOURCES slmpthread.h slmpthread.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appSCADA PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appSCADA
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appSCADA
    PRIVATE Qt6::Quick Qt6::QuickControls2 Qt6::Qml Qt6::Charts Qt6::Graphs Qt6::Core Qt6::Gui
)

# adding slmp library
# include_directories ("${CMAKE_CURRENT_SOURCE_DIR}/libslmp2/include")
# target_link_directories(appSCADA PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/libslmp2/lib")
# target_link_libraries(appSCADA PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/libslmp2/lib/libmelcli.lib")
# target_link_libraries(appSCADA PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/libslmp2/lib/libslmp.lib")

add_library(slmp_lib INTERFACE)
# Set include and link directories
target_include_directories(slmp_lib INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/libslmp2/include")
target_link_directories(slmp_lib INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/libslmp2/lib")
target_link_libraries(slmp_lib INTERFACE
    "${CMAKE_CURRENT_SOURCE_DIR}/libslmp2/lib/libmelcli.lib"
    "${CMAKE_CURRENT_SOURCE_DIR}/libslmp2/lib/libslmp.lib"
)

target_link_libraries(appSCADA PUBLIC slmp_lib)


include(GNUInstallDirs)
install(TARGETS appSCADA
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
add_subdirectory(SCADAQtWidgets)
