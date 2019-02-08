//
//  VegetableClient.swift
//  Rakusale
//
//  Created by 戸澤涼 on 2019/02/03.
//  Copyright © 2019 Ryo.Tozawa. All rights reserved.
//

import PromiseKit

class VegetableClient {
    static var shared = VegetableClient()

    let client = Vegetable_VegetablesServiceClient.init(address: RAKUSALE_API, secure: false)

    // rpc GetMyBoughtVegetables (GetMyVegetablesRequest) returns (GetMyVegetablesResponse) {}
    func getMyBoughtVegetables(token: String) -> Promise<[Vegetable_ResponseVegetable]> {
        var req = Vegetable_GetMyVegetablesRequest()
        req.token = token
    
        return Promise { seal in
            let _ = try? self.client.getMyBoughtVegetables(req, completion: {(response, result) in
                if result.success {
                    guard let vegetables = response?.vegetables else {return}
                    seal.fulfill(vegetables)
                } else {
                    guard let statusCode = response?.status else {return}
                    seal.reject(gRPCError.RequestError(statusCode))
                }
            })
        }
    }
    
    // rpc GetMySoldVegetables (GetMyVegetablesRequest) returns (GetMyVegetablesResponse) {}
    func getMySoldVegetables(token: String) -> Promise<[Vegetable_ResponseVegetable]> {
        var req = Vegetable_GetMyVegetablesRequest()
        req.token = token
        
        return Promise { seal in
            let _ = try? self.client.getMySoldVegetables(req, completion: {(response, result) in
                if result.success {
                    guard let vegetables = response?.vegetables else {return}
                    seal.fulfill(vegetables)
                } else {
                    guard let statusCode = response?.status else {return}
                    seal.reject(gRPCError.RequestError(statusCode))
                }
            })
        }
    }

    // rpc GetAllVegetables (VegetablesEmpty) returns (GetAllVegetablesResponse) {}
    func getAllVegetables() -> Promise<[Vegetable_ResponseVegetable]> {
        let req = Vegetable_VegetablesEmpty()
    
        return Promise { seal in
            let _ = try? self.client.getAllVegetables(req, completion: {(response, result) in
                if result.success {
                    guard let vegetables = response?.vegetables else {return}
                    seal.fulfill(vegetables)
                } else {
                    guard let statusCode = response?.status else {return}
                    seal.reject(gRPCError.RequestError(statusCode))
                }
            })
        }
    }
    
    func getSingleShopAllVegetables(shopID: Int64) -> Promise<[Vegetable_ResponseShopVegetable]> {
        LogService.shared.logger.info("[START] Call getSingleShopAllVegetablesRPC")
        var req = Vegetable_GetSingleShopAllVegetablesRequest()
        req.shopID = shopID
        
        return Promise { seal in
            let _ = try? self.client.getSingleShopAllVegetables(req, completion: {(response, result) in
                if result.success {
                    LogService.shared.logger.info("[SUCCESS] Call getSingleShopAllVegetablesRPC")
                    guard let vegetables = response?.vegetables else {return}
                    seal.fulfill(vegetables)
                } else {
                    LogService.shared.logger.error("[EXECUTE FAILURE!] on Calling getSingleShopAllVegetablesRPC")
                    guard let statusCode = response?.status else {return}
                    seal.reject(gRPCError.RequestError(statusCode))
                }
            })
            LogService.shared.logger.info("[END] Call getSingleShopAllVegetablesRPC")
        }
    }
    
    // rpc PostMyVegetable (PostMyVegetableRequest) returns (PostMyVegetableResponse) {}
    func postMyVegetable(
        token: String,
        name: String,
        fee: Int64,
        isChemical: Bool,
        productionDate: String,
        image: Data,
        category: Vegetable_VegetableType
    ) -> Promise<Void> {
        var req = Vegetable_PostMyVegetableRequest()
        var v = Vegetable_RequestVegetable()
        var i = Vegetable_VegetableImage()
        v.category = category
        v.fee = fee
        v.isChemical = isChemical
        v.productionDate = productionDate
        i.data = image
        req.token = token
        req.vegetable = v
        req.image = i
        
        return Promise { seal in
            let _ = try? self.client.postMyVegetable(req, completion: {(response, result) in
                if result.success {
                    seal.fulfill(())
                } else {
                    guard let statusCode = response?.status else {return}
                    seal.reject(gRPCError.RequestError(statusCode))
                }
            })
        }
    }
    // [Not Use Yet]
    func putMyVegetable() {
    
    }
    // [Not Use Yet]
    func deleteMyVegetable() {
    
    }
}
