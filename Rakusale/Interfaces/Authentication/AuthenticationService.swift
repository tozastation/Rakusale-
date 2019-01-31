//
//  AuthenticationService.swift
//  Rakusale-iOS
//
//  Created by 戸澤涼 on 2018/11/22.
//  Copyright © 2018 Ryo.Tozawa. All rights reserved.
//

import Foundation
import KeychainAccess

let S: Service.Type = Service.self

let SERVICE_NAME = "Rakusale.com"
let idKey = "RAKUSALE_USER_ID"
let isLogin = "LOGIN_STATE"

struct Service {
    private init(){}
    static let keychain = Keychain(service: SERVICE_NAME)
    static let userDefaults = UserDefaults.standard
}

// MARK: Keychain
enum Keychain_Keys: String {
    case Token = "Token"
}

extension Service {
    static func getKeychain(_ key: Keychain_Keys) -> String? {
        return keychain[key.rawValue]
    }
    
    static func setKeychain(_ key: Keychain_Keys, _ value: String?) {
        keychain[key.rawValue] = value
    }
}

// MARK: UserDefaults
enum UserDefaults_Keys: String {
    case isFirstLaunch = "isFirstLaunch"
}

extension Service {
    static func setDefaultUserDefaults() {
        userDefaults.register(defaults: [UserDefaults_Keys.isFirstLaunch.rawValue: true])
    }
    
    static func login() {
        UserDefaults.standard.set(true, forKey: isLogin)
    }
    
    static func logout() {
        UserDefaults.standard.set(false, forKey: isLogin)
    }
    
    static func loadLoginState() -> Bool {
        let result: Bool? = UserDefaults.standard.bool(forKey: isLogin)
        if result == nil {
            return false
        }
        return result!
    }
    
    static func setId(value: Int) -> Bool {
        var isDone: Bool = true
        if UserDefaults.standard.object(forKey: idKey) == nil {
            UserDefaults.standard.set(value, forKey: idKey)
        }else{
            isDone = false
        }
        return isDone
    }
    
    static func loadId() -> Int? {
        let userId: Int? = UserDefaults.standard.integer(forKey: idKey)
        return userId
    }
    
}
