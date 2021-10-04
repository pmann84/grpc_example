using Grpc.Core;
using Test;
using System;

namespace CSharpClient
{
    class Program
    {
        static void Main(string[] args)
        {
            Channel channel = new Channel("127.0.0.1:50051", ChannelCredentials.Insecure);

            var client = new Test.Greeter.GreeterClient(channel);
            string user = "you";

            var reply = client.SayHello(new HelloRequest { Name = user });

            channel.ShutdownAsync().Wait();
        }
    }
}
