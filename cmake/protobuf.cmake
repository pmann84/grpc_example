# Macro to generate grpc proto code in C++
macro(add_grpc_library LIBRARY_NAME PROTO_DIR)

    # Get the directories of the protoc and grpc plugin generation executables
    set(PROTOC_DIR "$<IF:$<CONFIG:Debug>,${CONAN_BIN_DIRS_PROTOBUF_DEBUG},${CONAN_BIN_DIRS_PROTOBUF_RELEASE}>")
    set(GRPC_PLUGIN_DIR "$<IF:$<CONFIG:Debug>,${CONAN_BIN_DIRS_GRPC_DEBUG},${CONAN_BIN_DIRS_GRPC_RELEASE}>")
    set(GEN_PROTOC_EXE ${PROTOC_DIR}/protoc.exe)
    set(GEN_GRPC_EXE ${GRPC_PLUGIN_DIR}/grpc_cpp_plugin.exe)
    message("Using protoc.exe at ${GEN_PROTOC_EXE}.")
    message("Using grpc plugin exe at ${GEN_GRPC_EXE}.")

    # Define generated c++ directory
    set(GGP_GENERATED_DIR ${CMAKE_CURRENT_BINARY_DIR}/generated)

    # For given proto dir, loop over every proto file
    get_filename_component(ABS_PROTO_DIR ${PROTO_DIR} ABSOLUTE)
    message("Searching ${ABS_PROTO_DIR} for proto definitions...")
    file(GLOB PROTO_FILES "${ABS_PROTO_DIR}/*.proto")
    foreach(PROTO_FILE ${PROTO_FILES})
        # Get absolute path
        get_filename_component(ABS_PROTO_FILEPATH ${PROTO_FILE} ABSOLUTE)
        message("Adding source files for ${ABS_PROTO_FILEPATH}")
        get_filename_component(PROTO_FILENAME ${ABS_PROTO_FILEPATH} NAME_WE)
        # Generate output file names
        set(PROTO_SRCS ${PROTO_SRCS} "${GGP_GENERATED_DIR}/${PROTO_FILENAME}.pb.cc")
        set(PROTO_HDRS ${PROTO_HDRS} "${GGP_GENERATED_DIR}/${PROTO_FILENAME}.pb.h")
        set(GRPC_SRCS ${GRPC_SRCS} "${GGP_GENERATED_DIR}/${PROTO_FILENAME}.grpc.pb.cc")
        set(GRPC_HDRS ${GRPC_HDRS} "${GGP_GENERATED_DIR}/${PROTO_FILENAME}.grpc.pb.h")
        set(ABS_PROTO_PATHS ${ABS_PROTO_PATHS} "${ABS_PROTO_FILEPATH}")
    endforeach()

    message("Proto Srcs: ${PROTO_SRCS}")
    message("Proto Hdrs: ${PROTO_HDRS}")
    message("gRPC Srcs: ${GRPC_SRCS}")
    message("gRPC Hdrs: ${GRPC_HDRS}")
    message("Proto def Paths: ${ABS_PROTO_PATHS}")

    # Add custom generation command
    add_custom_command(
            OUTPUT "${PROTO_SRCS}" "${PROTO_HDRS}" "${GRPC_SRCS}" "${GRPC_HDRS}"
            COMMAND ${GEN_PROTOC_EXE}
            ARGS --grpc_out "${GGP_GENERATED_DIR}"
            --cpp_out "${GGP_GENERATED_DIR}"
            -I "${ABS_PROTO_DIR}"
            --plugin=protoc-gen-grpc="${GEN_GRPC_EXE}"
            "${ABS_PROTO_PATHS}"
            DEPENDS "${ABS_PROTO_PATHS}")

    # Setup include paths
    include_directories("${GGP_GENERATED_DIR}")

    # Add new static library
    add_library(${LIBRARY_NAME}
            STATIC
            ${PROTO_SRCS}
            ${PROTO_HDRS}
            ${GRPC_SRCS}
            ${GRPC_HDRS})
    # Link necessary dependencies
    target_link_libraries(${LIBRARY_NAME}
            CONAN_PKG::protobuf
            CONAN_PKG::grpc)
endmacro()

macro(generate_protobufs)
    # Macro to generate proto code in C++
    # Inputs
    # Outputs
endmacro()