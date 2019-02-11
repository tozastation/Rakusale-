//
//  HomeShopViewController.swift
//  Rakusale-iOS
//
//  Created by 赤間 悠大 on 2018/10/19.
//  Copyright © 2018年 Ryo.Tozawa. All rights reserved.
//

import UIKit
import CoreLocation
import VegaScrollFlowLayout
import PromiseKit
import Kingfisher

class HomeShopViewController: UIViewController, UICollectionViewDataSource
{

    @IBOutlet weak var uiCollectionView: UICollectionView!
    fileprivate let refreshCtrl = UIRefreshControl()
    let imageNotFound = UIImage(named: "404")
    let layout = VegaScrollFlowLayout()
    let alert: UIAlertController = UIAlertController(title: "Invaild Login", message: "Please Retype", preferredStyle:  .alert)
    
    var shops: [Shop_ResponseShop] = []
    let waitTime: Double = 0.2
   
    lazy var loadingView: LOTAnimationView = {
        let animationView = LOTAnimationView(name: "glow_loading")
        animationView.frame = CGRect(x: 0, y: 0, width: (self.view.bounds.width)/2, height: (self.view.bounds.height)/2)
        animationView.center = self.view.center
        animationView.loopAnimation = true
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        
        return animationView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiCollectionView.delegate = self
        self.uiCollectionView.refreshControl = refreshCtrl
        refreshCtrl.addTarget(self, action: #selector(HomeShopViewController.refresh(sender:)), for: .valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.uiCollectionView.collectionViewLayout = layout
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: self.uiCollectionView.frame.width, height: 87)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        self.loadShops()
        let _ = LocalNotificationService.sharedManager.sendLocalNotification(title: "らくセール", subtitle: "入荷", body: "お気に入りの野菜が入荷しています")
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        self.loadShops()
        sender.endRefreshing()
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let shop: Shop_ResponseShop = self.shops[indexPath.row]
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8 // optional
        
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        let url: String = shop.imagePath
        LogService.shared.logger.debug(url)
        if url != "" {
            imageView.kf.setImage(with: ImageResource(downloadURL: URL(string: url)!))
        } else {
            imageView.image = self.imageNotFound
        }
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        
        // Label更新
        let nameLabel = cell.contentView.viewWithTag(2) as! UILabel
        nameLabel.text = shop.name
        
        let pinImage = cell.contentView.viewWithTag(3) as! UIImageView
        let redPin = UIImage(named: "Redpin")
        pinImage.image = redPin
        
        let locationLabel = cell.contentView.viewWithTag(4) as! UILabel
        let location =  CLLocation(latitude: Double(shop.latitude), longitude: Double(shop.longitude))
        LogService.shared.logger.debug(location)
        LogService.shared.logger.debug("↓")
        LogService.shared.logger.debug(SharedService.shared.reverseAddress)
        
        firstly {
            LocationService.sharedManager.ReverseGeocoder(location: location)
        }.done { address in
            if address != "" {
                locationLabel.text = address
                locationLabel.sizeToFit()
            } else {
                locationLabel.text = "地理情報を取得できませんでした"
                locationLabel.sizeToFit()
            }
        }.catch { e in
            LogService.shared.logger.error("[EXECUTE FAILURE!] on Calling getAllShopRPC")
            LogService.shared.logger.error("[Detail]" + e.localizedDescription)
            LogService.shared.logger.error("Present Alert Message")
        }

        nameLabel.sizeToFit()
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
        LogService.shared.logger.info("[START] Call loadShops")
        // Start Loading Animation
        self.startLoading()
        // Call RPC
        firstly {
            ShopClient.shared.getAllShop()
        }.done { shops in
            LogService.shared.logger.info("[SUCCESS] getAllShopRPC")
            self.shops = shops
            LogService.shared.logger.debug("↓[ResponseData]↓")
            LogService.shared.logger.debug(shops)
            DispatchQueue.main.asyncAfter(deadline: .now() + self.waitTime) {
                self.stopLoading()
                self.uiCollectionView.reloadData()
            }
        }.catch { e in
            LogService.shared.logger.error("[EXECUTE FAILURE!] on Calling getAllShopRPC")
            LogService.shared.logger.error("[Detail]" + e.localizedDescription)
            LogService.shared.logger.error("Present Alert Message")
            DispatchQueue.main.asyncAfter(deadline: .now() + self.waitTime) {
                self.stopLoading()
                self.present(self.alert, animated: true, completion: nil)
            }
        }
        LogService.shared.logger.info("[END] Call loadShops")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // くるくる開始
    func startLoading() {
        view.addSubview(loadingView)
        loadingView.play()
    }
    
    // くるくるteisi
    func stopLoading() {
        self.loadingView.removeFromSuperview()
    }
}

extension HomeShopViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width), height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        LogService.shared.logger.info("[START] didSelectItemAt on pushing Cell")
        //let selectedShop = self.shops[indexPath.item]
        SharedService.shared.segueShop = self.shops[indexPath.item]
        let location =  CLLocation(latitude: Double(self.shops[indexPath.item].latitude), longitude: Double(self.shops[indexPath.item].longitude))
        LocationService.sharedManager.ReverseGeocoder(location: location)
        performSegue(withIdentifier: "ShopVegetables", sender: nil)
        LogService.shared.logger.info("[END] didSelectItemAt on pushing Cell")
    }
}
