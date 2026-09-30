qt_add_executable(appsaya
    main.cpp
)

qt_add_qml_module(appsaya
    URI saya              # must match loadFromModule("saya", "Main") in main.cpp
    VERSION 1.0
    QML_FILES Main.qml
)

set_target_properties(appsaya PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER ch.yourname.saya
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appsaya
    PRIVATE Qt6::Quick engine
)

include(GNUInstallDirs)
install(TARGETS appsaya
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)