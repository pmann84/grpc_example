add_executable(grpc_client main.cpp)
target_link_libraries(grpc_client ${PROTO_PROJECT_NAME})
#target_link_libraries(grpc_server CONAN_PKG::protobuf)