#include <test.grpc.pb.h>

#include <grpcpp/grpcpp.h>

#include <sstream>

class greeter_client
{
public:
    greeter_client(std::shared_ptr<grpc::Channel> channel) : m_stub(test::Greeter::NewStub(channel))
    {
    }

    std::string say_hello(const std::string& user)
    {
        test::HelloRequest request;
        request.set_name(user);

        test::HelloReply reply;
        grpc::ClientContext context;

        grpc::Status status = m_stub->SayHello(&context, request, &reply);

        if (status.ok())
        {
            return reply.message();
        }
        else
        {
            std::stringstream ss;
            ss << "RPC failed: " << status.error_code() << ": " << status.error_message()
                      << std::endl;
            return ss.str();
        }
    }

private:
    std::unique_ptr<test::Greeter::Stub> m_stub;
};

int main(int argc, char** argv)
{
    // Instantiate the client. It requires a channel, out of which the actual RPCs
    // are created. This channel models a connection to an endpoint specified by
    // the argument "--target=" which is the only expected argument.
    // We indicate that the channel isn't authenticated (use of
    // InsecureChannelCredentials()).
    std::string target_str;
    std::string arg_str("--target");
    if (argc > 1) {
        std::string arg_val = argv[1];
        size_t start_pos = arg_val.find(arg_str);
        if (start_pos != std::string::npos) {
            start_pos += arg_str.size();
            if (arg_val[start_pos] == '=') {
                target_str = arg_val.substr(start_pos + 1);
            } else {
                std::cout << "The only correct argument syntax is --target="
                          << std::endl;
                return 0;
            }
        } else {
            std::cout << "The only acceptable argument is --target=" << std::endl;
            return 0;
        }
    } else {
        target_str = "localhost:50051";
    }
    greeter_client greeter(
            grpc::CreateChannel(target_str, grpc::InsecureChannelCredentials()));
    std::string user("world");
    std::string reply = greeter.say_hello(user);
    std::cout << "Greeter received: " << reply << std::endl;
    return 0;
}

