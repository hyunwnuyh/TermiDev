cmake_minimum_required(VERSION 3.1)
set ( CMAKE_C_COMPILER /usr/bin/gcc )
set ( CMAKE_C_STANDARD <std> )
add_compile_options ( -g -Wall )

set ( PROJECT_NAME <proj_name> )
file( GLOB_RECURSE SRC_FILES *.c *.h )
set ( LINK_DIRS lib )

project ( $PROJECT_NAME )

link_directories ( ${LINK_DIRS})

set ( CMAKE_ARCHIVE_OUTPUT_DIRECTORY ..)
set ( CMAKE_LIBRARY_OUTPUT_DIRECTORY ..)
set ( CMAKE_RUNTIME_OUTPUT_DIRECTORY ..)

add_library ( <proj_name> ${SRC_FILES} )
