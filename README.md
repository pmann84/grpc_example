# grpc_example
An example gRPC project with a C++ server using CMake and Conan.  Various clients in different languages.

## Build and Run C++ Server and Client
The following commands build the generate the C++ versions of the proto defs and the C++ server and client
```mkdir cmake-debug
cd cmake-debug
cmake -DCMAKE_BUILD_TYPE=Debug ..
cmake --build . --config Debug
```

## Build and Run C# Client
The following commands build the generate the C# versions of the proto defs and the C# client itself 
```cd CSharpClient
dotnet build
dotnet run```
