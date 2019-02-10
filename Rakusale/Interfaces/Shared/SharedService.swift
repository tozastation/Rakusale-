//
//  SharedService.swift
//  Rakusale
//
//  Created by 戸澤涼 on 2019/02/10.
//  Copyright © 2019 Ryo.Tozawa. All rights reserved.
//

import Foundation

class SharedService {
    static var shared = SharedService()
    var segueVegetable: Vegetable_ResponseShopVegetable!
    var segueShop: Shop_ResponseShop!
}
