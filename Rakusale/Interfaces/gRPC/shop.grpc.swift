//
// DO NOT EDIT.
//
// Generated by the protocol buffer compiler.
// Source: shop.proto
//

//
// Copyright 2018, gRPC Authors All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import Foundation
import Dispatch
import SwiftGRPC
import SwiftProtobuf

internal protocol Shop_ShopsGetMyShopCall: ClientCallUnary {}

fileprivate final class Shop_ShopsGetMyShopCallBase: ClientCallUnaryBase<Shop_GetMyShopRequest, Shop_GetMyShopResponse>, Shop_ShopsGetMyShopCall {
  override class var method: String { return "/shop.Shops/GetMyShop" }
}

internal protocol Shop_ShopsGetAllShopsCall: ClientCallUnary {}

fileprivate final class Shop_ShopsGetAllShopsCallBase: ClientCallUnaryBase<Shop_ShopsEmpty, Shop_GetAllShopsResponse>, Shop_ShopsGetAllShopsCall {
  override class var method: String { return "/shop.Shops/GetAllShops" }
}

internal protocol Shop_ShopsPostMyShopCall: ClientCallUnary {}

fileprivate final class Shop_ShopsPostMyShopCallBase: ClientCallUnaryBase<Shop_PostMyShopRequest, Shop_PostMyShopResponse>, Shop_ShopsPostMyShopCall {
  override class var method: String { return "/shop.Shops/PostMyShop" }
}

internal protocol Shop_ShopsPutMyShopCall: ClientCallUnary {}

fileprivate final class Shop_ShopsPutMyShopCallBase: ClientCallUnaryBase<Shop_PutMyShopRequest, Shop_PutMyShopResponse>, Shop_ShopsPutMyShopCall {
  override class var method: String { return "/shop.Shops/PutMyShop" }
}

internal protocol Shop_ShopsDeleteMyShopCall: ClientCallUnary {}

fileprivate final class Shop_ShopsDeleteMyShopCallBase: ClientCallUnaryBase<Shop_DeleteMyShopRequest, Shop_DeleteMyShopResponse>, Shop_ShopsDeleteMyShopCall {
  override class var method: String { return "/shop.Shops/DeleteMyShop" }
}


/// Instantiate Shop_ShopsServiceClient, then call methods of this protocol to make API calls.
internal protocol Shop_ShopsService: ServiceClient {
  /// Synchronous. Unary.
  func getMyShop(_ request: Shop_GetMyShopRequest) throws -> Shop_GetMyShopResponse
  /// Asynchronous. Unary.
  func getMyShop(_ request: Shop_GetMyShopRequest, completion: @escaping (Shop_GetMyShopResponse?, CallResult) -> Void) throws -> Shop_ShopsGetMyShopCall

  /// Synchronous. Unary.
  func getAllShops(_ request: Shop_ShopsEmpty) throws -> Shop_GetAllShopsResponse
  /// Asynchronous. Unary.
  func getAllShops(_ request: Shop_ShopsEmpty, completion: @escaping (Shop_GetAllShopsResponse?, CallResult) -> Void) throws -> Shop_ShopsGetAllShopsCall

  /// Synchronous. Unary.
  func postMyShop(_ request: Shop_PostMyShopRequest) throws -> Shop_PostMyShopResponse
  /// Asynchronous. Unary.
  func postMyShop(_ request: Shop_PostMyShopRequest, completion: @escaping (Shop_PostMyShopResponse?, CallResult) -> Void) throws -> Shop_ShopsPostMyShopCall

  /// Synchronous. Unary.
  func putMyShop(_ request: Shop_PutMyShopRequest) throws -> Shop_PutMyShopResponse
  /// Asynchronous. Unary.
  func putMyShop(_ request: Shop_PutMyShopRequest, completion: @escaping (Shop_PutMyShopResponse?, CallResult) -> Void) throws -> Shop_ShopsPutMyShopCall

  /// Synchronous. Unary.
  func deleteMyShop(_ request: Shop_DeleteMyShopRequest) throws -> Shop_DeleteMyShopResponse
  /// Asynchronous. Unary.
  func deleteMyShop(_ request: Shop_DeleteMyShopRequest, completion: @escaping (Shop_DeleteMyShopResponse?, CallResult) -> Void) throws -> Shop_ShopsDeleteMyShopCall

}

internal final class Shop_ShopsServiceClient: ServiceClientBase, Shop_ShopsService {
  /// Synchronous. Unary.
  internal func getMyShop(_ request: Shop_GetMyShopRequest) throws -> Shop_GetMyShopResponse {
    return try Shop_ShopsGetMyShopCallBase(channel)
      .run(request: request, metadata: metadata)
  }
  /// Asynchronous. Unary.
  internal func getMyShop(_ request: Shop_GetMyShopRequest, completion: @escaping (Shop_GetMyShopResponse?, CallResult) -> Void) throws -> Shop_ShopsGetMyShopCall {
    return try Shop_ShopsGetMyShopCallBase(channel)
      .start(request: request, metadata: metadata, completion: completion)
  }

  /// Synchronous. Unary.
  internal func getAllShops(_ request: Shop_ShopsEmpty) throws -> Shop_GetAllShopsResponse {
    return try Shop_ShopsGetAllShopsCallBase(channel)
      .run(request: request, metadata: metadata)
  }
  /// Asynchronous. Unary.
  internal func getAllShops(_ request: Shop_ShopsEmpty, completion: @escaping (Shop_GetAllShopsResponse?, CallResult) -> Void) throws -> Shop_ShopsGetAllShopsCall {
    return try Shop_ShopsGetAllShopsCallBase(channel)
      .start(request: request, metadata: metadata, completion: completion)
  }

  /// Synchronous. Unary.
  internal func postMyShop(_ request: Shop_PostMyShopRequest) throws -> Shop_PostMyShopResponse {
    return try Shop_ShopsPostMyShopCallBase(channel)
      .run(request: request, metadata: metadata)
  }
  /// Asynchronous. Unary.
  internal func postMyShop(_ request: Shop_PostMyShopRequest, completion: @escaping (Shop_PostMyShopResponse?, CallResult) -> Void) throws -> Shop_ShopsPostMyShopCall {
    return try Shop_ShopsPostMyShopCallBase(channel)
      .start(request: request, metadata: metadata, completion: completion)
  }

  /// Synchronous. Unary.
  internal func putMyShop(_ request: Shop_PutMyShopRequest) throws -> Shop_PutMyShopResponse {
    return try Shop_ShopsPutMyShopCallBase(channel)
      .run(request: request, metadata: metadata)
  }
  /// Asynchronous. Unary.
  internal func putMyShop(_ request: Shop_PutMyShopRequest, completion: @escaping (Shop_PutMyShopResponse?, CallResult) -> Void) throws -> Shop_ShopsPutMyShopCall {
    return try Shop_ShopsPutMyShopCallBase(channel)
      .start(request: request, metadata: metadata, completion: completion)
  }

  /// Synchronous. Unary.
  internal func deleteMyShop(_ request: Shop_DeleteMyShopRequest) throws -> Shop_DeleteMyShopResponse {
    return try Shop_ShopsDeleteMyShopCallBase(channel)
      .run(request: request, metadata: metadata)
  }
  /// Asynchronous. Unary.
  internal func deleteMyShop(_ request: Shop_DeleteMyShopRequest, completion: @escaping (Shop_DeleteMyShopResponse?, CallResult) -> Void) throws -> Shop_ShopsDeleteMyShopCall {
    return try Shop_ShopsDeleteMyShopCallBase(channel)
      .start(request: request, metadata: metadata, completion: completion)
  }

}

/// To build a server, implement a class that conforms to this protocol.
/// If one of the methods returning `ServerStatus?` returns nil,
/// it is expected that you have already returned a status to the client by means of `session.close`.
internal protocol Shop_ShopsProvider: ServiceProvider {
  func getMyShop(request: Shop_GetMyShopRequest, session: Shop_ShopsGetMyShopSession) throws -> Shop_GetMyShopResponse
  func getAllShops(request: Shop_ShopsEmpty, session: Shop_ShopsGetAllShopsSession) throws -> Shop_GetAllShopsResponse
  func postMyShop(request: Shop_PostMyShopRequest, session: Shop_ShopsPostMyShopSession) throws -> Shop_PostMyShopResponse
  func putMyShop(request: Shop_PutMyShopRequest, session: Shop_ShopsPutMyShopSession) throws -> Shop_PutMyShopResponse
  func deleteMyShop(request: Shop_DeleteMyShopRequest, session: Shop_ShopsDeleteMyShopSession) throws -> Shop_DeleteMyShopResponse
}

extension Shop_ShopsProvider {
  internal var serviceName: String { return "shop.Shops" }

  /// Determines and calls the appropriate request handler, depending on the request's method.
  /// Throws `HandleMethodError.unknownMethod` for methods not handled by this service.
  internal func handleMethod(_ method: String, handler: Handler) throws -> ServerStatus? {
    switch method {
    case "/shop.Shops/GetMyShop":
      return try Shop_ShopsGetMyShopSessionBase(
        handler: handler,
        providerBlock: { try self.getMyShop(request: $0, session: $1 as! Shop_ShopsGetMyShopSessionBase) })
          .run()
    case "/shop.Shops/GetAllShops":
      return try Shop_ShopsGetAllShopsSessionBase(
        handler: handler,
        providerBlock: { try self.getAllShops(request: $0, session: $1 as! Shop_ShopsGetAllShopsSessionBase) })
          .run()
    case "/shop.Shops/PostMyShop":
      return try Shop_ShopsPostMyShopSessionBase(
        handler: handler,
        providerBlock: { try self.postMyShop(request: $0, session: $1 as! Shop_ShopsPostMyShopSessionBase) })
          .run()
    case "/shop.Shops/PutMyShop":
      return try Shop_ShopsPutMyShopSessionBase(
        handler: handler,
        providerBlock: { try self.putMyShop(request: $0, session: $1 as! Shop_ShopsPutMyShopSessionBase) })
          .run()
    case "/shop.Shops/DeleteMyShop":
      return try Shop_ShopsDeleteMyShopSessionBase(
        handler: handler,
        providerBlock: { try self.deleteMyShop(request: $0, session: $1 as! Shop_ShopsDeleteMyShopSessionBase) })
          .run()
    default:
      throw HandleMethodError.unknownMethod
    }
  }
}

internal protocol Shop_ShopsGetMyShopSession: ServerSessionUnary {}

fileprivate final class Shop_ShopsGetMyShopSessionBase: ServerSessionUnaryBase<Shop_GetMyShopRequest, Shop_GetMyShopResponse>, Shop_ShopsGetMyShopSession {}

internal protocol Shop_ShopsGetAllShopsSession: ServerSessionUnary {}

fileprivate final class Shop_ShopsGetAllShopsSessionBase: ServerSessionUnaryBase<Shop_ShopsEmpty, Shop_GetAllShopsResponse>, Shop_ShopsGetAllShopsSession {}

internal protocol Shop_ShopsPostMyShopSession: ServerSessionUnary {}

fileprivate final class Shop_ShopsPostMyShopSessionBase: ServerSessionUnaryBase<Shop_PostMyShopRequest, Shop_PostMyShopResponse>, Shop_ShopsPostMyShopSession {}

internal protocol Shop_ShopsPutMyShopSession: ServerSessionUnary {}

fileprivate final class Shop_ShopsPutMyShopSessionBase: ServerSessionUnaryBase<Shop_PutMyShopRequest, Shop_PutMyShopResponse>, Shop_ShopsPutMyShopSession {}

internal protocol Shop_ShopsDeleteMyShopSession: ServerSessionUnary {}

fileprivate final class Shop_ShopsDeleteMyShopSessionBase: ServerSessionUnaryBase<Shop_DeleteMyShopRequest, Shop_DeleteMyShopResponse>, Shop_ShopsDeleteMyShopSession {}

