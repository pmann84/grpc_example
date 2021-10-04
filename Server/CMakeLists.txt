

add_executable(grpc_server main.cpp)
target_link_libraries(grpc_server ${PROTO_PROJECT_NAME})
#target_link_libraries(grpc_server CONAN_PKG::protobuf)

set_target_properties(grpc_server PROPERTIES LINK_FLAGS "/ignore:4099")