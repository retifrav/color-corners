cmake_minimum_required(VERSION 3.20)

project("color-corners"
    DESCRIPTION "Simple application with basic QML"
    VERSION 0.0.2
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 17)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

# for Sublime Text LSP
#set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(QT NAMES Qt6 COMPONENTS Quick Qml REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Quick Qml REQUIRED)

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
