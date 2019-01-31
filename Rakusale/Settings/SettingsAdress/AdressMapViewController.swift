//
//  AdressMapViewController.swift
//  Rakusale-iOS
//
//  Created by 赤間 悠大 on 2018/12/02.
//  Copyright © 2018年 Ryo.Tozawa. All rights reserved.
//

import UIKit
import MapKit

class AdressMapViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    var address:String!
    var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        let coordinate = CLLocationCoordinate2DMake(41.775037, 140.725296)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.mapView.setRegion(region
            , animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.view.endEditing(true)
        address = searchBar.text
        geocoder.geocodeAddressString(address, completionHandler: {(placeMark:[CLPlacemark]?, error:Error?) -> Void in
            if let placeMark = placeMark?[0] {
                let coordinate = CLLocationCoordinate2DMake(placeMark.location!.coordinate.latitude,placeMark.location!.coordinate.longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2DMake(placeMark.location!.coordinate.latitude,placeMark.location!.coordinate.longitude)
                annotation.title = "この位置で登録します。"
                self.mapView.setRegion(region, animated: true)
                self.mapView.addAnnotation(annotation)
                let parentVC = self.parent as! SettingsAdressViewController
                parentVC.resultAction(self.address, latitude: String(placeMark.location!.coordinate.latitude), longitude: String(placeMark.location!.coordinate.longitude))
                
            }
        })
    }
}
