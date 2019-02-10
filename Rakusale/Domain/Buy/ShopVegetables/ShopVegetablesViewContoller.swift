//
//  ShopVegetables.swift
//  Rakusale
//
//  Created by 戸澤涼 on 2019/02/05.
//  Copyright © 2019 Ryo.Tozawa. All rights reserved.
//

import Foundation
import CoreLocation
import PromiseKit
import VegaScrollFlowLayout
import Kingfisher

class ShopVegetablesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
   
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var uiCollectionView: UICollectionView!
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopAddressLabel: UILabel!
    @IBOutlet weak var shopIntroText: UITextView!
    @IBOutlet weak var shopFavButton: UIButton!
    
    fileprivate let refreshCtl = UIRefreshControl()
    let layout = VegaScrollFlowLayout()
    let imageNotFound = UIImage(named: "404")
    var recieveShop: Shop_ResponseShop!
    var recieveVegetables: [Vegetable_ResponseShopVegetable] = []
    let waitTime: Double = 0.2
    let alert: UIAlertController = UIAlertController(title: "Invaild Login", message: "Please Retype", preferredStyle:  .alert)
    
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
        self.shopNameLabel.text = SharedService.shared.segueShop.name
        self.shopIntroText.text = SharedService.shared.segueShop.introduction
        let location: CLLocation = CLLocation(latitude: Double(SharedService.shared.segueShop.latitude), longitude: Double(SharedService.shared.segueShop.longitude))
        
        self.shopAddressLabel.text = LocationService.sharedManager.ReverseGeocoder(location: location)
        self.uiCollectionView.dataSource = self
        self.uiCollectionView.delegate = self
        self.uiCollectionView.collectionViewLayout = layout
        
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: uiCollectionView.frame.width, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        
        uiView.layer.borderColor = UIColor.black.cgColor
        uiView.layer.borderWidth = 1
        uiView.layer.cornerRadius = 20
       
        shopFavButton.layer.cornerRadius = 5.0
        
        self.uiCollectionView.refreshControl = refreshCtl
        refreshCtl.addTarget(self, action: #selector(ShopVegetablesViewController.refresh(sender:)), for: .valueChanged)
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        self.loadShopVegetables(shopID: SharedService.shared.segueShop.id)
        sender.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadShopVegetables(shopID: SharedService.shared.segueShop.id)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let vegetable: Vegetable_ResponseShopVegetable = self.recieveVegetables[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) //as! MDCCardCollectionCell
        cell.backgroundColor = UIColor.clear
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8 // optional
        
        let imageView = cell.contentView.viewWithTag(5) as! UIImageView
        let url: String = vegetable.imagePath
        if url != "" {
            imageView.kf.setImage(with: ImageResource(downloadURL: URL(string: url)!))
        } else {
            imageView.image = self.imageNotFound
        }
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        
        let nameLabel = cell.contentView.viewWithTag(1) as! UILabel
        nameLabel.text = vegetable.name
        nameLabel.sizeToFit()
        let intro = cell.contentView.viewWithTag(2) as! UITextView
        intro.text = "サーバ側の実装忘れた"
        intro.sizeToFit()

        let amountLabel = cell.contentView.viewWithTag(3) as! UILabel
        amountLabel.text = String(vegetable.amount) + "個"
        amountLabel.sizeToFit()

        let valueLabel = cell.contentView.viewWithTag(4) as! UILabel
        valueLabel.text = String(vegetable.fee) + "円"
        valueLabel.sizeToFit()
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recieveVegetables.count
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
    
    func loadShopVegetables(shopID: Int64) {
        LogService.shared.logger.info("[START] Call loadShops")
        // Start Loading Animation
        self.startLoading()
        // Call RPC
        firstly {
            VegetableClient.shared.getSingleShopAllVegetables(shopID: shopID)
            }.done { vegetables in
                self.recieveVegetables = vegetables
                LogService.shared.logger.debug("↓[ResponseData]↓")
                LogService.shared.logger.debug(vegetables)
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
    
    @IBAction func didTapReturn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ShopVegetablesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width), height: (collectionView.bounds.height) / 2.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SharedService.shared.segueVegetable = self.recieveVegetables[indexPath.item]
        performSegue(withIdentifier: "BuyVegetablesVC", sender: nil)
    }
}
