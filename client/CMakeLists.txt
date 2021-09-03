cmake_minimum_required (VERSION 3.13)

include("${CMAKE_CURRENT_SOURCE_DIR}/.cmake/Vcpkg.cmake")

# Project Configuration

project (
	"Public transport"
	VERSION 1.0.0
)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON)

# Debug configuration

if(CMAKE_BUILD_TYPE MATCHES DEBUG)
    if(MSVC)
        add_compile_options(/Wall /fsanitize=address)
    else()
        add_compile_options(-Wall -Wextra -pedantic -fms-extensions -fsanitize=address)
        add_link_options(-fsanitize=address)
    endif(MSVC)
endif(CMAKE_BUILD_TYPE MATCHES DEBUG)

# Guards

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
    message(
    FATAL_ERROR
    "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there."
    )
endif()

# Dependencies

file(STRINGS "${CMAKE_CURRENT_SOURCE_DIR}/.dependencies" DEPENDENCY_LIST)
install_dependencies("${DEPENDENCY_LIST}")

# Executable

find_package(libmysql CONFIG REQUIRED)
set(MYSQL_INCLUDE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/vcpkg/installed/x64-windows/include/mysql")

add_executable(
    public-transport  
    "src/amministratore.c"
    "src/defines.h"
    "src/guidatore.c"
    "src/main.c"
    "src/passeggero.c"
    "src/utils.c"
)
target_include_directories(public-transport PRIVATE ${MYSQL_INCLUDE_DIRS})
target_link_libraries(public-transport PRIVATE ${MYSQL_LIBRARIES})
