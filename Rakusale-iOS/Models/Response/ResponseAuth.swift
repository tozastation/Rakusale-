//
//  ResponseToken.swift
//  Rakusale-iOS
//
//  Created by 戸澤涼 on 2018/11/22.
//  Copyright © 2018 Ryo.Tozawa. All rights reserved.
//

import Foundation

struct ResponseAuth: Codable {
    var userId: Int
    var accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case accessToken = "access_token"
    }
}

