//
//  HomeShopViewController.swift
//  Rakusale-iOS
//
//  Created by 赤間 悠大 on 2018/10/19.
//  Copyright © 2018年 Ryo.Tozawa. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import AlamofireImage
import VegaScrollFlowLayout

class HomeShopViewController: UIViewController, UICollectionViewDataSource
{

    @IBOutlet weak var uiCollectionView: UICollectionView!
    var shops: [ResponseShop] = []
    fileprivate let refreshCtrl = UIRefreshControl()
    let imageCache = AutoPurgingImageCache()
    let imageNotFound = UIImage(named: "404")
    let layout = VegaScrollFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiCollectionView.delegate = self
        self.uiCollectionView.refreshControl = refreshCtrl
        refreshCtrl.addTarget(self, action: #selector(HomeShopViewController.refresh(sender:)), for: .valueChanged)
        self.loadShops()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.uiCollectionView.collectionViewLayout = layout
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: self.uiCollectionView.frame.width, height: 87)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        self.loadShops()
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        self.loadShops()
        sender.endRefreshing()
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let shop: ResponseShop = self.shops[indexPath.row]
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        let url: String = shop.imagePath
        if let image = imageCache.image(withIdentifier: url){
            imageView.image = image
        }else{
            Alamofire.request(url).responseImage { response in
                if let image = response.result.value {
                    imageView.image = image
                    self.imageCache.add(image, withIdentifier: url)
                }else{
                    imageView.image = self.imageNotFound
                }
            }
        }
        let nameLabel = cell.contentView.viewWithTag(2) as! UILabel
        nameLabel.text = shop.name
        let pinImage = cell.contentView.viewWithTag(3) as! UIImageView
        let redPin = UIImage(named: "Redpin")
        pinImage.image = redPin
        let locationLabel = cell.contentView.viewWithTag(4) as! UILabel
        let location = CLLocation(latitude: shop.latitude, longitude: shop.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placeMark:[CLPlacemark]?, error:Error?) -> Void in
            if let placeMark = placeMark?[0]{
                locationLabel.text = String(placeMark.administrativeArea!) + String(placeMark.locality!) + String(placeMark.thoroughfare!) + String(placeMark.subThoroughfare!)
            }
        })
        nameLabel.sizeToFit()
        locationLabel.sizeToFit()
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.layer.masksToBounds = false
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shops.count
    }
    
    func loadShops() {
        var request = URLRequest(url: URL(string: SHOP_REST)!)
        request.httpMethod = HTTPMethod.get.rawValue
        Alamofire.request(request).responseJSON {
            response in
            if response.result.isSuccess {
                if let data = response.data {
                    self.shops = try! JSONDecoder().decode([ResponseShop].self, from: data)
                    self.uiCollectionView.reloadData()
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension HomeShopViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width), height: 100)
    }
}
