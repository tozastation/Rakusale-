//
//  UserModel.swift
//  Rakusale-iOS
//
//  Created by 戸澤涼 on 2018/10/21.
//  Copyright © 2018 Ryo.Tozawa. All rights reserved.
//

import Foundation

struct RequestUser: Codable {
    var shopId: Int?
    var name: String
    var email: String
    var birthDay: String?
    var isSaler: Bool
    var isBuyer: Bool
    var password: String
}
