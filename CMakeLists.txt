#### cmake -G "Visual Studio 16 2019" -A x64 ..
cmake_minimum_required(VERSION 3.19)

# Project settings
project(
        grpc_test
        VERSION 0.0.1
        DESCRIPTION ""
        LANGUAGES CXX
)

# CMake C++ standards
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Who doesnt like to know the compilation commands...
set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Disable the ZERO_CHECK project generation
set(CMAKE_SUPPRESS_REGENERATION true)

# CMake scripts
include(cmake/conan.cmake) # Conan Package Manager
include(cmake/protobuf.cmake)

# Set up Conan dependencies
set(CONAN_EXTRA_OPTIONS "")
set(CONAN_EXTRA_REQUIRES ${CONAN_EXTRA_REQUIRES}
        grpc/1.38.0
)
run_conan()

# Build Protocol files
set(PROTO_PROJECT_NAME grpc_protocol)
add_grpc_library(${PROTO_PROJECT_NAME} ./protos)

# Supplementary
add_subdirectory(server)
add_subdirectory(client)