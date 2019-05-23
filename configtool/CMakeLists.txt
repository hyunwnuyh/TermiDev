cmake_minimum_required(VERSION 3.1)
list(APPEND CMAKE_MODULE_PATH "cmake")

set ( CMAKE_C_COMPILER /usr/bin/gcc )
set ( CMAKE_C_STANDARD 99 )
add_compile_options ( -g -Wall )


set ( PROJECT_NAME configtool )
file( GLOB_RECURSE SRC_FILES src/*.c )
set ( INCLUDE_DIRS inc )
set ( LINK_DIRS lib )

project ( $PROJECT_NAME )

include_directories( ${INCLUDE_DIRS} )
link_directories ( ${LINK_DIRS})

set ( CMAKE_ARCHIVE_OUTPUT_DIRECTORY ..)
set ( CMAKE_LIBRARY_OUTPUT_DIRECTORY ..)
set ( CMAKE_RUNTIME_OUTPUT_DIRECTORY ..)

add_executable ( tool ${SRC_FILES} )
target_link_libraries ( tool /usr/lib/x86_64-linux-gnu/libncurses.so )
