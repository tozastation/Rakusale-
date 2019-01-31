//
//  ResponseUser.swift
//  Rakusale-iOS
//
//  Created by 赤間 悠大 on 2018/11/16.
//  Copyright © 2018年 Ryo.Tozawa. All rights reserved.
//

import Foundation


struct ResponseShop: Codable {
    var id: Int
    var imagePath: String
    var name: String
    var introduction: String
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case imagePath = "image_path"
        case name
        case introduction
        case latitude
        case longitude
    }
}

