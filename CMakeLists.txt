cmake_minimum_required(VERSION 3.20)

project("color-corners"
    DESCRIPTION "Simple application with basic QML"
    VERSION 0.0.2
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 17)

list(APPEND CMAKE_MODULE_PATH
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake"
)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

# for Sublime Text LSP
#set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Quick Qml QmlWorkerScript REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Quick Qml QmlWorkerScript REQUIRED)

if (Qt${QT_VERSION_MAJOR}_FOUND)
    get_filename_component(QT_HOME "${Qt${QT_VERSION_MAJOR}_DIR}/../../.." ABSOLUTE)
    message(STATUS "Found Qt ${QT_VERSION}: ${QT_HOME}")
else()
    message(FATAL_ERROR "Couldn't find Qt")
endif()

if(UNIX)
    if(NOT APPLE)
        find_package(Threads REQUIRED)
        find_package(X11 REQUIRED)
    endif()
endif()

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    if(APPLE)
        qt_add_executable(${CMAKE_PROJECT_NAME}
            MACOSX_BUNDLE
            MANUAL_FINALIZATION
        )
    elseif(WIN32)
        qt_add_executable(${CMAKE_PROJECT_NAME}
            WIN32
            MANUAL_FINALIZATION
        )
    else()
        qt_add_executable(${CMAKE_PROJECT_NAME}
            MANUAL_FINALIZATION
        )
    endif()
else()
    if(APPLE)
        add_executable(${CMAKE_PROJECT_NAME} MACOSX_BUNDLE)
    elseif(WIN32)
        add_executable(${CMAKE_PROJECT_NAME} WIN32)
    else()
        add_executable(${CMAKE_PROJECT_NAME})
    endif()
endif()

get_target_property(QT_TARGET_TYPE Qt${QT_VERSION_MAJOR}::Core TYPE)
if(${QT_TARGET_TYPE} STREQUAL "STATIC_LIBRARY")
    message(STATUS "This Qt is static")

    # from 5.14 there is a standard function for this
    set(QT_VERSION_WITH_QML_IMPORTS 5.14)
    if(${QT_VERSION} VERSION_EQUAL ${QT_VERSION_WITH_QML_IMPORTS}
        OR ${QT_VERSION} VERSION_GREATER ${QT_VERSION_WITH_QML_IMPORTS}
    )
        message(STATUS "This Qt version (${QT_VERSION}) is newer than ${QT_VERSION_WITH_QML_IMPORTS}")
        find_package(Qt5QmlImportScanner REQUIRED)
        qt5_import_qml_plugins(${CMAKE_PROJECT_NAME})
    else() # use a custom module
        message(STATUS "This Qt version (${QT_VERSION}) is older than ${QT_VERSION_WITH_QML_IMPORTS}")
        include(QtStaticPlugins)
        # this adds lots of unused modules and actually is not needed at all, as it seems
        #qt_generate_plugin_import(${CMAKE_PROJECT_NAME}
        #    OUTPUT "${CMAKE_PROJECT_NAME}_plugin_import.cpp"
        #    OUTPUT_DIR "${PROJECT_BINARY_DIR}"
        #    #VERBOSE
        #)
        qt_generate_qml_plugin_import(${CMAKE_PROJECT_NAME}
            QML_DIR "${QT_HOME}/qml"
            QML_SRC "${CMAKE_CURRENT_SOURCE_DIR}"
            OUTPUT "${CMAKE_PROJECT_NAME}_qml_plugin_import.cpp"
            OUTPUT_DIR "${PROJECT_BINARY_DIR}"
            #VERBOSE
        )
        # this target needs to be linked after qt_generate_qml_plugin_import call
        if(TARGET Qt${QT_VERSION_MAJOR}::QmlWorkerScript)
            target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE Qt${QT_VERSION_MAJOR}::QmlWorkerScript)
        endif()
    endif()
else()
    message(STATUS "This Qt is ${QT_TARGET_TYPE}")
endif()

set(sources
    main.cpp
)

qt_add_resources(sources qml.qrc)

target_sources(${CMAKE_PROJECT_NAME}
    PRIVATE
        ${sources}
)

target_include_directories(${CMAKE_PROJECT_NAME}
    PRIVATE
        #${CMAKE_CURRENT_SOURCE_DIR}
        "${PROJECT_BINARY_DIR}/include/"
)

#target_compile_definitions(${CMAKE_PROJECT_NAME}
#  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(${CMAKE_PROJECT_NAME}
    PRIVATE
        Qt${QT_VERSION_MAJOR}::Quick
        Qt${QT_VERSION_MAJOR}::Qml
)

if (UNIX)
    if (APPLE)
        # target_link_libraries(${CMAKE_PROJECT_NAME}
        #     "-framework Cocoa"
        #     "-framework IOKit"
        #     "-framework CoreVideo"
        # )
    else()
        target_link_libraries(${CMAKE_PROJECT_NAME}
            PRIVATE
                ${CMAKE_THREAD_LIBS_INIT}
                ${X11_LIBRARIES}
                ${CMAKE_DL_LIBS}
        )
    endif()
endif()

if (APPLE)
    set_target_properties(${CMAKE_PROJECT_NAME}
        PROPERTIES
            MACOSX_BUNDLE_GUI_IDENTIFIER "dev.decovar"
            MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION} # CFBundleLongVersionString, deprecated
            MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION} # CFBundleShortVersionString
    )
endif()

if(QT_VERSION_MAJOR EQUAL 6)
    qt_import_qml_plugins(${CMAKE_PROJECT_NAME})
    qt_finalize_executable(${CMAKE_PROJECT_NAME})
endif()

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_CURRENT_BINARY_DIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_CURRENT_BINARY_DIR})
