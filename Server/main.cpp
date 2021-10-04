#include <iostream>

#include <grpcpp/ext/proto_server_reflection_plugin.h>
#include <grpcpp/grpcpp.h>
#include <grpcpp/health_check_service_interface.h>

#include <test.grpc.pb.h>
#include <test.pb.h>

class greeter_service_impl final : public test::Greeter::Service
{
    grpc::Status SayHello(grpc::ServerContext* context, const test::HelloRequest* request, test::HelloReply* reply) override
    {
        std::cout << "Recieved request: " << request->name() << std::endl;
        std::string prefix("Hello ");
        reply->set_message(prefix + request->name());
        return grpc::Status::OK;
    }

    grpc::Status SayHelloAgain(grpc::ServerContext* context, const test::HelloRequest* request, test::HelloReply* reply) override
    {
        std::string prefix("Hello ");
        reply->set_message(prefix + request->name() + " again!");
        return grpc::Status::OK;
    }

    grpc::Status SayHelloAgainAgain(grpc::ServerContext* context, const test::HelloRequest* request, test::HelloReply* reply) override
    {
        std::string prefix("Hello ");
        reply->set_message(prefix + request->name() + " again, again!");
        return grpc::Status::OK;
    }
};

void run_server()
{
    std::string server_address("0.0.0.0:50051");
    greeter_service_impl service;

    grpc::EnableDefaultHealthCheckService(true);
    grpc::reflection::InitProtoReflectionServerBuilderPlugin();

    // Build the server with no authentication
    grpc::ServerBuilder builder;
    builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());
    builder.RegisterService(&service);

    // Assemble the server
    std::unique_ptr<grpc::Server> server(builder.BuildAndStart());
    std::cout << "Server listening on: " << server_address << std::endl;

    // Wait for server to shut down. Some other
    // thread must be responsible for shutting
    // down the server otherwise this call will
    // never return.
    server->Wait();
}

int main()
{
    run_server();
    return 0;
}
