//
//  LocationService.swift
//  Rakusale-iOS
//
//  Created by 戸澤涼 on 2018/12/01.
//  Copyright © 2018 Ryo.Tozawa. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import RealmSwift
import Realm

class LocationService: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    private var locationManager : CLLocationManager!
    private var  status = CLLocationManager.authorizationStatus()
    let radius: Double = 100
    
    // シングルトン
    static let sharedManager = LocationService()
    private override init() {
        super.init()
        self.locationManager = CLLocationManager.init()
        self.locationManager.allowsBackgroundLocationUpdates = true // バックグランドモードで使用する場合YESにする必要がある
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest // 位置情報取得の精度
        self.locationManager.distanceFilter = 15 // 位置情報取得する間隔、1m単位とする
        self.locationManager.delegate = self
    }
    // 位置情報noninnsyoujyoutaiwokakuninn
    func checkLocationAuthentication(){
        if (status == .notDetermined) {
            print("許可、不許可を選択してない"); // DEBUG
            locationManager.requestAlwaysAuthorization(); // 常に許可するように求める
        }else if (status == .restricted) {
            print("機能制限している"); // DEBUG
        }else if (status == .denied) {
            print("許可していない"); // DEBUG
        }else if (status == .authorizedWhenInUse) {
            print("このアプリ使用中のみ許可している"); // DEBUG
            locationManager.startUpdatingLocation();
        }else if (status == .authorizedAlways) {
            print("常に許可している");
            locationManager.startUpdatingLocation();
        }
    }
    
    // 位置情報が取得されると呼ばれる
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location : CLLocation = locations.last! // 最新の位置情報を取得 locationsに配列で入っている位置情報の最後が最新となる
        print(location.coordinate)
        let latitude: Double = location.coordinate.latitude
        let longitude: Double = location.coordinate.longitude
        let currentPoint = (latitude, longitude) // 現在をタプルに変換
        let shopList = RealmService.sharedManager.getShopModel()// Realmからデータを取ってくる
        let result = self.calcNearlyShops(shops: shopList, current: currentPoint)// 近隣の直売所を検索
        print("付近の直売所です")
        print(result)
        if result.count != 0 {
            let title = "らくセール"
            let subtitle = "近くに直売所があります"
            let body = result[0].name
            let result = LocalNotificationService.sharedManager.sendLocalNotification(title: title, subtitle: subtitle, body: body)
        }
    }

    
    func distance(current: (la: Double, lo: Double), target: (la: Double, lo: Double)) -> Double {
        // 緯度経度をラジアンに変換
        let currentLa   = current.la * Double.pi / 180
        let currentLo   = current.lo * Double.pi / 180
        let targetLa    = target.la * Double.pi / 180
        let targetLo    = target.lo * Double.pi / 180
        // 赤道半径
        let equatorRadius = 6378137.0;
        // 算出
        let averageLat = (currentLa - targetLa) / 2
        let averageLon = (currentLo - targetLo) / 2
        let distance = equatorRadius * 2 * asin(sqrt(pow(sin(averageLat), 2) + cos(currentLa) * cos(targetLa) * pow(sin(averageLon), 2)))
        return distance / 1000
    }
    
    func calcNearlyShops(shops: Results<RealmShop>, current: (la: Double, lo: Double)) -> [RealmShop] {
        var a: [RealmShop] = []
        for shop in shops {
            let targetPoint = (shop.latitude, shop.longitude)
            let diff = distance(current: current, target: targetPoint)
            if diff <= self.radius {
                a.append(shop)
            }
        }
        return a
    }
}
