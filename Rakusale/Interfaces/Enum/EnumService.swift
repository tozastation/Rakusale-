//
//  EnumService.swift
//  Rakusale
//
//  Created by 戸澤涼 on 2019/02/03.
//  Copyright © 2019 Ryo.Tozawa. All rights reserved.
//

import Foundation

class EnumService {
    static var shared = EnumService()
    
    var vegetableOption = [
        "カボチャ",
        "キャベツ",
        "キュウリ",
        "さつまいも",
        "じゃがいも",
        "大根",
        "玉ねぎ",
        "人参",
        "ピーマン",
        "ホウレンソウ",
        "レタス"
    ]
    
    // 入力した値と対応表
    func convertEnum(v: String) -> Vegetable_VegetableType? {
        switch v {
        case "カボチャ":
            return Vegetable_VegetableType.init(rawValue: 0)!
        case "キャベツ":
            return Vegetable_VegetableType.init(rawValue: 1)!
        case "キュウリ":
            return Vegetable_VegetableType.init(rawValue: 2)!
        case "さつまいも":
            return Vegetable_VegetableType.init(rawValue: 3)!
        case "じゃがいも":
            return Vegetable_VegetableType.init(rawValue: 4)!
        case "大根":
            return Vegetable_VegetableType.init(rawValue: 5)!
        case "玉ねぎ":
            return Vegetable_VegetableType.init(rawValue: 6)!
        case "人参":
            return Vegetable_VegetableType.init(rawValue: 7)!
        case "ピーマン":
            return Vegetable_VegetableType.init(rawValue: 8)!
        case "ホウレンソウ":
            return Vegetable_VegetableType.init(rawValue: 9)!
        case "レタス":
            return Vegetable_VegetableType.init(rawValue: 10)!
        default:
            return nil
        }
    }
}
