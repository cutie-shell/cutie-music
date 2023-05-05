cmake_minimum_required(VERSION 3.16)
project(cutie-music VERSION 1.0 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick Qml LinguistTools)
find_package(PkgConfig REQUIRED)

qt_standard_project_setup()

set(cutie-music_SOURCES 
        src/appcore.cpp
        src/appcore.h
        src/coverimageprovider.cpp
        src/coverimageprovider.h
        src/main.cpp
)

qt_add_resources(APP_RESOURCES 
	${CMAKE_SOURCE_DIR}/src/qml/qml.qrc
	${CMAKE_SOURCE_DIR}/assets/assets.qrc)

qt_add_executable(cutie-music ${cutie-music_SOURCES} ${APP_RESOURCES})

qt_add_translations(cutie-music
    TS_FILES ${CMAKE_SOURCE_DIR}/translations/cutie-music_fi.ts)

pkg_check_modules(TAGLIB REQUIRED taglib)

target_compile_options(cutie-music PUBLIC ${TAGLIB_CFLAGS_OTHER})

target_include_directories(cutie-music PUBLIC src ${TAGLIB_INCLUDE_DIRS})

target_link_libraries(cutie-music PUBLIC Qt::Core Qt::Quick Qt::Qml ${TAGLIB_LIBRARIES})

install(TARGETS cutie-music RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}")
install(FILES cutie-music.desktop DESTINATION "${CMAKE_INSTALL_DATADIR}/applications")
install(FILES cutie-music.svg DESTINATION "${CMAKE_INSTALL_DATADIR}/icons/hicolor/scalable/apps")