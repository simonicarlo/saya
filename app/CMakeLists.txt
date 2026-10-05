qt_add_executable(appsaya
    main.cpp
)

# Singletons must be marked before qt_add_qml_module sees them, so the
# generated qmldir declares them as singletons rather than plain types.
set_source_files_properties(Theme.qml Colors.qml Fmt.qml MockData.qml
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE
)

qt_add_qml_module(appsaya
    URI saya              # must match loadFromModule("saya", "Main") in main.cpp
    VERSION 1.0
    QML_FILES
        Main.qml
        # design tokens and helpers
        Theme.qml
        Colors.qml
        Fmt.qml
        MockData.qml
        # views, one per application state
        EmptyView.qml
        ScanView.qml
        ResultsView.qml
        # components
        TopBar.qml
        ByteField.qml
        TypeLegend.qml
        ResultTable.qml
        DetailPane.qml
        HexDump.qml
        FilledButton.qml
        QuietButton.qml
        DevStrip.qml
)

set_target_properties(appsaya PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER ch.yourname.saya
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appsaya
    PRIVATE Qt6::Quick Qt6::QuickLayouts engine
)

include(GNUInstallDirs)
install(TARGETS appsaya
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
