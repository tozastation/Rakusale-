//
//  RealmService.swift
//  Rakusale-iOS
//
//  Created by 戸澤涼 on 2018/12/02.
//  Copyright © 2018 Ryo.Tozawa. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class RealmService {
    let realm = try! Realm()
    
    // シングルトン
    static let sharedManager = RealmService()
    
//    func getShops() -> Observable<DataResponse<Any>> {
//        return self.apiService.getShopsResponse()
//    }
    
    // Alamofireでリクエストを取得したら，SaveArrayを呼び出す
//    func insertShops() {
//        getShops()
//            .subscribe(
//                onNext: { response in
//                    if response.result.isSuccess {
//                        if let data = response.data {
//                            print(response)
//                            let shops = try? JSONDecoder().decode([ResponseShop].self, from: data)
//                            self.saveArrayShops(object: shops!)
//                            print(shops!)
//                        }
//                    }
//            },
//                onCompleted: {
//                    print("終わり")
//            }).disposed(by: DisposeBag())
//    }
    func insertShops(){
//        var request = URLRequest(url: URL(string: SHOP_REST)!)
//        request.httpMethod = HTTPMethod.get.rawValue
//        request.timeoutInterval = 5.0
//        Alamofire.request(request).responseJSON {
//            response in
//            if response.result.isSuccess {
//                if let data = response.data {
//                    print(response)
//                    let shops = try! JSONDecoder().decode([ResponseShop].self, from: data)
//                    self.saveArrayShops(object: shops)
//                }
//            }else {
//            }
//        }
    }
        
    func getRealmPath() -> URL {
        let result = Realm.Configuration.defaultConfiguration.fileURL!
        return result
    }
    // 受け取った直売所のモデルをRealmモデルに変換してDBに挿入
    func saveArrayShops(object: [ResponseShop]) {
        for a in object {// リストから一個ずつ読み込み
            try! self.realm.write { // realmにえオブジェクトを永続データとして，保存する準備
                let b = self.shopToRealmModel(shop: a) // オブジェクトの型を変換する関数
                self.realm.add(b, update: true) // 挿入開始
            }
        }
    }
    
    // Convert ResponseShop Model to RealmShop Model
    func shopToRealmModel(shop: ResponseShop) -> Object {
        let realmShop = RealmShop()
        realmShop.id = shop.id
        realmShop.name = shop.name
        realmShop.imagePath = shop.imagePath
        realmShop.latitude = shop.latitude
        realmShop.longitude = shop.longitude
        return realmShop
    }
    
    func getShopModel() -> Results<RealmShop> {
        let shopList = realm.objects(RealmShop.self)
        return shopList
    }
}
