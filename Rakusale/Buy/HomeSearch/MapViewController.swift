//
//  MapViewController.swift
//  Rakusale-iOS
//
//  Created by 赤間 悠大 on 2018/12/01.
//  Copyright © 2018年 Ryo.Tozawa. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate  {
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        CLLocationManager.locationServicesEnabled()
        
        // セキュリティ認証のステータス
        let status = CLLocationManager.authorizationStatus()
        
        if(status == CLAuthorizationStatus.notDetermined) {
            print("NotDetermined")
            // 許可をリクエスト
            locationManager.requestWhenInUseAuthorization()
            
        }
        else if(status == CLAuthorizationStatus.restricted){
            print("Restricted")
        }
        else if(status == CLAuthorizationStatus.authorizedWhenInUse){
            print("authorizedWhenInUse")
        }
        else if(status == CLAuthorizationStatus.authorizedAlways){
            print("authorizedAlways")
        }
        else{
            print("not allowed")
        }
        let coordinate = mapView.userLocation.coordinate
        //let coordinate = CLLocationCoordinate2DMake(37.331652997806785, -122.03072304117417)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.mapView.setRegion(region, animated:true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(41.841817, 140.766969)
        annotation.title = "らくセール直売所"
        self.mapView.addAnnotation(annotation)
        self.mapView.userTrackingMode = MKUserTrackingMode.follow
        self.mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        // 表示タイプを航空写真と地図のハイブリッドに設定
        // self.mapView.mapType = MKMapType.hybrid
        self.mapView.mapType = MKMapType.standard
        // self.mapView.mapType = MKMapType.satellite
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.animatesDrop = true
        }
        else {
            pinView?.annotation = annotation
        }
        pinView?.pinTintColor = UIColor.green
        pinView?.canShowCallout = true
        let rightButton: AnyObject! = UIButton(type: UIButton.ButtonType.detailDisclosure)
        pinView?.rightCalloutAccessoryView = rightButton as? UIView
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let parentVC = self.parent as! HomeSearchViewController
        parentVC.ShopInformation()
    }
}
