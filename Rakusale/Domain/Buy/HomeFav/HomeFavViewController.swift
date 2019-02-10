//
//  HomeFavViewController.swift
//  Rakusale-iOS
//
//  Created by 赤間 悠大 on 2018/10/19.
//  Copyright © 2018年 Ryo.Tozawa. All rights reserved.
//

import UIKit
import Kingfisher
import PromiseKit

class HomeFavViewController: UIViewController {

    @IBOutlet weak var uiCollectionView: UICollectionView!
    var shops : [Shop_ResponseShop] = []
    fileprivate let refreshCtl = UIRefreshControl()
    let imageNotFound = UIImage(named: "404")
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
        self.navigationController?.isNavigationBarHidden = false
        self.uiCollectionView.delegate = self
        self.uiCollectionView.refreshControl = refreshCtl
        refreshCtl.addTarget(self, action: #selector(HomeSellViewController.refresh(sender:)), for: .valueChanged)
        self.loadShops()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadShops()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        self.loadShops()
        sender.endRefreshing()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        // お店インスタンス生成
        let shop: Shop_ResponseShop = self.shops[indexPath.row]
        // Identifer振ってるやつのインスタンス生成
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "Cell",
            for: indexPath
        )
        cell.backgroundColor = UIColor.clear
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8 // optional
        // 画像データ取得
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        let url: String = shop.imagePath
        if url != "" {
            imageView.kf.setImage(with: ImageResource(downloadURL: URL(string: url)!))
        } else {
            imageView.image = self.imageNotFound
        }
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        // 名前のラベル設定
        let name = cell.contentView.viewWithTag(2) as! UILabel
        name.text = shop.name
        // 料金のラベル設定
        name.sizeToFit()
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shops.count;
    }
    
    // ユーザーデータをGETで取得後，collectionViewをリロードsurusyori
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.stopLoading()
                    self.uiCollectionView.reloadData()
                }
            }.catch { e in
                LogService.shared.logger.error("[EXECUTE FAILURE!] on Calling getAllShopRPC")
                LogService.shared.logger.error("[Detail]" + e.localizedDescription)
                LogService.shared.logger.error("Present Alert Message")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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

extension HomeFavViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 13) / 4, height: (collectionView.bounds.width - 13) / 4)
    }
}

