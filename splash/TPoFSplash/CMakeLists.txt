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
endif ()

add_executable(tpofsplash ${TPoFSplash_SRCS} ${tpofsplash_RESOURCES_RCC} ${RES_FILES})
target_link_libraries(tpofsplash Qt5::Core Qt5::Widgets)

install(TARGETS tpofsplash RUNTIME DESTINATION bin)
