//
//  Shop.swift
//  Rakusale-iOS
//
//  Created by 赤間 悠大 on 2018/11/16.
//  Copyright © 2018年 Ryo.Tozawa. All rights reserved.
//

import Foundation

struct RequestShop: Codable {
    var userId: Int
    var imagePath: String
    var name: String
    var introduction: String
    var latitude: String
    var longitude: String
}
