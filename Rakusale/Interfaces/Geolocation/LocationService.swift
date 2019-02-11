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
import PromiseKit

class LocationService: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    private var locationManager : CLLocationManager!
    private var  status = CLLocationManager.authorizationStatus()
    
    var location: CLLocation!
    var longitude: Double!
    var latitude: Double!
    
    let radius: Double = 1000
    
    // シングルトン
    static let sharedManager = LocationService()
    private override init() {
        super.init()
        self.locationManager = CLLocationManager.init()
        self.locationManager.allowsBackgroundLocationUpdates = true // バックグランドモードで使用する場合YESにする必要がある
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest // 位置情報取得の精度
        self.locationManager.distanceFilter = 100 // 位置情報取得する間隔、1m単位とする
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
    
    func updateLocation() {
        self.locationManager.requestLocation()
        self.location = self.locationManager.location
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
    
    // 位置情報が取得されると呼ばれる
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last! // 最新の位置情報を取得 locationsに配列で入っている位置情報の最後が最新となる
        print(location.coordinate)
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        let currentPoint = (self.latitude, self.longitude) // 現在をタプルに変換
        firstly {
            ShopClient.shared.getAllShop()
        }.done { shops in
            LogService.shared.logger.debug(shops)
            let result = self.calcNearlyShops(shops: shops, current: currentPoint as! (la: Double, lo: Double))
            LogService.shared.logger.debug(result)
            if result.count != 0 {
                let title = "らくセール"
                let subtitle = "近くに直売所があります"
                let body = result[0].name
                let _ = LocalNotificationService.sharedManager.sendLocalNotification(title: title, subtitle: subtitle, body: body)
            }
        }.catch { e in
            LogService.shared.logger.error("[EXECUTE FAILURE!] on Calling buyVegetablesRPC")
            LogService.shared.logger.error("[Detail]" + e.localizedDescription)
            LogService.shared.logger.error("Present Alert Message")
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
    
    func calcNearlyShops(shops: [Shop_ResponseShop], current: (la: Double, lo: Double)) -> [Shop_ResponseShop] {
        var a: [Shop_ResponseShop] = []
        for shop in shops {
            let targetPoint = (Double(shop.latitude), Double(shop.longitude))
            let diff = distance(current: current, target: targetPoint)
            if diff <= self.radius {
                a.append(shop)
            }
        }
        return a
    }
    
    func ReverseGeocoder(location: CLLocation) -> Promise<String>{
        let geocoder = CLGeocoder()
        var address: String  = ""
        SharedService.shared.reverseAddress = ""
        return Promise { seal in
            let _ = try? geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if error != nil {
                    seal.reject(gRPCError.RequestError(400))
                } else {
                    if let placemarks = placemarks {
                        if let pm = placemarks.first {
                            LogService.shared.logger.debug(pm)
//                            if pm.locality?.isEmpty != nil {
//                                SharedService.shared.reverseAddress += pm.locality!
//                            }
//                            if pm.subLocality?.isEmpty != nil {
//                                SharedService.shared.reverseAddress += pm.subLocality!
//                            }
                            if pm.thoroughfare?.isEmpty != nil {
                                SharedService.shared.reverseAddress += pm.thoroughfare!
                                address = pm.thoroughfare!
                            }
                        }
                        seal.fulfill(address)
                    }
                }
            }
        }
    }
    
    func makeAddressString(placemark: CLPlacemark) -> String {
        var address: String = ""
        //address += placemark.postalCode != nil ? placemark.postalCode! : ""
        address += placemark.administrativeArea != nil ? placemark.administrativeArea! : ""
        address += placemark.subAdministrativeArea != nil ? placemark.subAdministrativeArea! : ""
        address += placemark.locality != nil ? placemark.locality! : ""
        address += placemark.subLocality != nil ? placemark.subLocality! : ""
        address += placemark.thoroughfare != nil ? placemark.thoroughfare! : ""
        address += placemark.subThoroughfare != nil ? placemark.subThoroughfare! : ""
        
        return address
    }
}
