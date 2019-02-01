//
//  EntryClient.swift
//  Rakusale
//
//  Created by 戸澤涼 on 2019/01/31.
//  Copyright © 2019 Ryo.Tozawa. All rights reserved.
//

import Foundation
import PromiseKit

class EntryClient {
    static var shared = EntryClient()
    
    let client = Entry_EntrysServiceClient.init(address: RAKUSALE_API, secure: false)
    
    func signIn(email: String, password: String) -> Promise<String> {
        var req = Entry_SignInRequest()
        req.email = email
        req.password = password
        
        return Promise { seal in
            let _ = try? self.client.signIn(req, completion: {(response, result) in
                if result.success {
                    guard let token = response?.token else {return}
                    seal.fulfill(token)
                } else {
                    guard let statusCode = response?.status else {return}
                    seal.reject(gRPCError.RequestError(statusCode))
                }
            })
        }
    }
    
    func signUp(
        name: String,
        email: String,
        birthday: String,
        isSaler: Bool,
        isBuyer: Bool,
        password: String
    ) -> Promise<String> {
        var req = Entry_SignUpRequest()
        req.name = name
        req.email = email
        req.birthday = birthday
        req.isSaler = isSaler
        req.isBuyer = isBuyer
        req.password = password
        
        return Promise { seal in
            let _ = try? self.client.signUp(req, completion: { (response, result) in
                if result.success {
                    guard let token = response?.token else {return}
                    seal.fulfill(token)
                } else {
                    guard let statusCode = response?.status else {return}
                    seal.reject(gRPCError.RequestError(statusCode))
                }
            })
        }
    }
}
