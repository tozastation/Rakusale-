//
//  RealmShop.swift
//  Rakusale-iOS
//
//  Created by 戸澤涼 on 2018/12/02.
//  Copyright © 2018 Ryo.Tozawa. All rights reserved.
//

import Foundation
import RealmSwift

class RealmShop: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var imagePath: String = ""
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
