// Code generated by protoc-gen-go-grpc. DO NOT EDIT.
// versions:
// - protoc-gen-go-grpc v1.2.0
// - protoc             v3.21.12
// source: hcmcore.proto

package pb

import (
	grpc "google.golang.org/grpc"
)

// This is a compile-time assertion to ensure that this generated file
// is compatible with the grpc package it is being compiled against.
// Requires gRPC-Go v1.32.0 or later.
const _ = grpc.SupportPackageIsVersion7

// HCMCoreServiceClient is the client API for HCMCoreService service.
//
// For semantics around ctx use and closing/ending streaming RPCs, please refer to https://pkg.go.dev/google.golang.org/grpc/?tab=doc#ClientConn.NewStream.
type HCMCoreServiceClient interface {
}

type hCMCoreServiceClient struct {
	cc grpc.ClientConnInterface
}

func NewHCMCoreServiceClient(cc grpc.ClientConnInterface) HCMCoreServiceClient {
	return &hCMCoreServiceClient{cc}
}

// HCMCoreServiceServer is the server API for HCMCoreService service.
// All implementations must embed UnimplementedHCMCoreServiceServer
// for forward compatibility
type HCMCoreServiceServer interface {
	mustEmbedUnimplementedHCMCoreServiceServer()
}

// UnimplementedHCMCoreServiceServer must be embedded to have forward compatible implementations.
type UnimplementedHCMCoreServiceServer struct {
}

func (UnimplementedHCMCoreServiceServer) mustEmbedUnimplementedHCMCoreServiceServer() {}

// UnsafeHCMCoreServiceServer may be embedded to opt out of forward compatibility for this service.
// Use of this interface is not recommended, as added methods to HCMCoreServiceServer will
// result in compilation errors.
type UnsafeHCMCoreServiceServer interface {
	mustEmbedUnimplementedHCMCoreServiceServer()
}

func RegisterHCMCoreServiceServer(s grpc.ServiceRegistrar, srv HCMCoreServiceServer) {
	s.RegisterService(&HCMCoreService_ServiceDesc, srv)
}

// HCMCoreService_ServiceDesc is the grpc.ServiceDesc for HCMCoreService service.
// It's only intended for direct use with grpc.RegisterService,
// and not to be introspected or modified (even as a copy)
var HCMCoreService_ServiceDesc = grpc.ServiceDesc{
	ServiceName: "entities.HCMCoreService",
	HandlerType: (*HCMCoreServiceServer)(nil),
	Methods:     []grpc.MethodDesc{},
	Streams:     []grpc.StreamDesc{},
	Metadata:    "hcmcore.proto",
}
