//
//  Vegetable.swift
//  Rakusale-iOS
//
//  Created by 赤間 悠大 on 2018/11/16.
//  Copyright © 2018年 Ryo.Tozawa. All rights reserved.
//

import Foundation

struct RequestVegetable: Codable {
    var shopId: Int
    var name: String
    var fee: Int64
    var isChemical: Bool
    var imagePath: String
    var productonDate: String
}
