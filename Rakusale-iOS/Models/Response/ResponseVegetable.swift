//
//  ResponseVegetable.swift
//  Rakusale-iOS
//
//  Created by 戸澤涼 on 2018/11/16.
//  Copyright © 2018 Ryo.Tozawa. All rights reserved.
//

import Foundation


struct ResponseVegetable: Codable {
    var id: Int
    var shopId: Int?
    var name: String
    var fee: Int64
    var isChemical: Bool
    var imagePath: String
    var productonDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case shopId = "shop_id"
        case name
        case fee
        case isChemical = "is_chemical"
        case imagePath = "image_path"
        case productonDate = "production_date"
    }
}
