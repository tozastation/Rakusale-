//
//  EntryClient.swift
//  Rakusale
//
//  Created by 戸澤涼 on 2019/01/31.
//  Copyright © 2019 Ryo.Tozawa. All rights reserved.
//

import Foundation
import PromiseKit

class ShopClient {
    static var shared = ShopClient()
    
    let client = Shop_ShopsServiceClient.init(address: RAKUSALE_API, secure: false)
    
    func getMyShop(token: String) -> Promise<Shop_ResponseShop> {
        var req = Shop_GetMyShopRequest()
        req.token = token
        
        return Promise { seal in
            let _ = try? self.client.getMyShop(req, completion: {(response, result) in
                if result.success {
                    guard let shop = response?.shop else {return}
                    seal.fulfill(shop)
                } else {
                    guard let statusCode = response?.status else {return}
                    seal.reject(gRPCError.RequestError(statusCode))
                }
            })
        }
    }
    
    func getAllShop() -> Promise<[Shop_ResponseShop]> {
        let req = Shop_ShopsEmpty()
        
        return Promise { seal in
            let _ = try? self.client.getAllShops(req, completion: {(response, result) in
                if result.success {
                    guard let shops = response?.shops else {return}
                    seal.fulfill(shops)
                } else {
                    guard let statusCode = response?.status else {return}
                    seal.reject(gRPCError.RequestError(statusCode))
                }
            })
        }
    }
    
    func postMyShop(name: String, latitude: Float, longitude: Float, intro: String, data: Data, token: String) -> Promise<Void> {
        var req = Shop_PostMyShopRequest()
        req.shop.name = name
        req.shop.latitude = latitude
        req.shop.longitude = longitude
        req.shop.introduction = intro
        req.image.data = data
        req.token = token
        
        return Promise { seal in
            let _ = try? self.client.postMyShop(req, completion: {(response, result) in
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
    func putMyShop() {
        
    }
    // [Not Use Yet]
    func DeleteMyShop() {
        
    }
}
