cmake_minimum_required(VERSION 3.0)
project(tpofsplash)

# Find includes in corresponding build directories
set(CMAKE_INCLUDE_CURRENT_DIR ON)
# Instruct CMake to run moc automatically when needed.
set(CMAKE_AUTOMOC ON)

# Handle .rcc files automatically
set(CMAKE_AUTORCC ON)

# Find all Qt modules which are required
find_package(Qt5Core)
find_package(Qt5Widgets)

set(TPoFSplash_SRCS main.cpp)

QT5_ADD_RESOURCES(tpofsplash_RESOURCES_RCC resource.qrc)

set(RES_FILES "")
# Add a resource file containing the icon. This adds an icon to the executable.
if (WIN32)
    set(RES_FILES "${CMAKE_SOURCE_DIR}/client.rc")
    set(CMAKE_RC_COMPILER_INIT windres)
    ENABLE_LANGUAGE(RC)
    SET(CMAKE_RC_COMPILE_OBJECT "<CMAKE_RC_COMPILER> <FLAGS> -O coff <DEFINES> -i <SOURCE> -o <OBJECT>")

    if (NOT "${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
        # Don't show a console in release mode on Windows: -mwindows
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mwindows")
    endif ()
endif ()

add_executable(tpofsplash ${TPoFSplash_SRCS} ${tpofsplash_RESOURCES_RCC} ${RES_FILES})
target_link_libraries(tpofsplash Qt5::Core Qt5::Widgets)
set_target_properties(tpofsplash PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/TPoF")
set_target_properties(tpofsplash PROPERTIES OUTPUT_NAME "The Power of Fire")

# Installs all required Qt binary files on Windows.
# The program windeployqt generates all files into the binary directory which have to be installed
if (WIN32)
    # Make sure the output directory is cleaned everytime a clean is done since there might be different DLLs when distributing the relase version.
    set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "${CMAKE_BINARY_DIR}/TPoF")
    find_program(WINDEPLOYQT_PROGRAM windeployqt)

    if ("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
        set(WINDEPLOYQT_ARGS "--debug")
    else ()
        set(WINDEPLOYQT_ARGS "--release")
    endif ()

    set(WINDEPLOYQT_ARGS ${WINDEPLOYQT_ARGS} "--no-translations" "--no-system-d3d-compiler" "--no-angle"  "--no-opengl-sw")
    add_custom_target(deployqt ALL ${WINDEPLOYQT_PROGRAM} $<TARGET_FILE:tpofsplash> ${WINDEPLOYQT_ARGS} --dir "${CMAKE_BINARY_DIR}/TPoF" DEPENDS tpofsplash)
endif ()

install(TARGETS tpofsplash RUNTIME DESTINATION bin)
