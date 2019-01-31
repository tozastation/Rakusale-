//
//  ResponseShop.swift
//  Rakusale-iOS
//
//  Created by 赤間 悠大 on 2018/11/16.
//  Copyright © 2018年 Ryo.Tozawa. All rights reserved.
//

import Foundation


struct ResponseUser: Codable {
    var id: Int
    var shopId: Int
    var name: String
    var email: String
    var birthDay: String
    var isSaler: Bool
    var isBuyer: Bool
    var password: String
  
    enum CodingKeys: String, CodingKey {
        case id
        case shopId = "shop_id"
        case name
        case email
        case birthDay = "birth_day"
        case isSaler = "is_saler"
        case isBuyer = "is_buyer"
        case password
    }
}
