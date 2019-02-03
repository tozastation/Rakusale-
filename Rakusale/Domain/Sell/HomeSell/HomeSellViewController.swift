//
//  HomeSellViewController.swift
//  Rakusale-iOS
//
//  Created by 赤間 悠大 on 2018/10/17.
//  Copyright © 2018年 Ryo.Tozawa. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import PromiseKit
import VegaScrollFlowLayout

class HomeSellViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var uiCollectionView: UICollectionView!
    var vegetables : [Vegetable_ResponseVegetable] = []
    fileprivate let refreshCtl = UIRefreshControl()
    let imageCache = AutoPurgingImageCache()
    let imageNotFound = UIImage(named: "404")
    let layout = VegaScrollFlowLayout()
    let waitTime: Double = 2.0
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
        uiCollectionView.collectionViewLayout = layout
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: uiCollectionView.frame.width, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        // 画面引っ張ったらくるくる回って更新するためのインスタンス
        self.uiCollectionView.refreshControl = refreshCtl
        refreshCtl.addTarget(self, action: #selector(HomeSellViewController.refresh(sender:)), for: .valueChanged)
        self.loadVegetables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadVegetables()
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        self.loadVegetables()
        sender.endRefreshing()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        // 野菜インスタンス生成
        let vegetable: Vegetable_ResponseVegetable = self.vegetables[indexPath.row]
        // Identifer振ってるやつのインスタンス生成
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "Cell",
            for: indexPath
        )
//        cell.layer.borderColor = UIColor.black.cgColor
//        cell.layer.cornerRadius = 30
//        cell.layer.masksToBounds = true
        // 画像データ取得
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        let url: String = vegetable.imagePath
        // イメージパスをキーとして、画像をキャッシュ
        if let image = imageCache.image(withIdentifier: url) {
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
        // 名前のラベル設定
        let name = cell.contentView.viewWithTag(2) as! UILabel
        name.text = vegetable.name
        // 料金のラベル設定
        let fee = cell.contentView.viewWithTag(3) as! UILabel
        fee.text = String(vegetable.fee) + "円"
        name.sizeToFit()
        fee.sizeToFit()
        cell.alpha = 0
        UIView.animate(withDuration: 1.8) {
            cell.alpha = 1
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vegetables.count
    }
    
    // 野菜データをGETで取得後，collectionViewをリロードsurusyori
    func loadVegetables() {
        // Start Loading Animation
        self.startLoading()
        // Call RPC
        print("Activate Login")
         let token = S.getKeychain(Keychain_Keys.Token)!
        firstly {
            VegetableClient.shared.getMySoldVegetables(token: token)
        }.done { vegetables in
            self.vegetables = vegetables
            DispatchQueue.main.asyncAfter(deadline: .now() + self.waitTime) {
                self.stopLoading()
                self.uiCollectionView.reloadData()
            }
        }.catch { e in
            print(e)
            DispatchQueue.main.asyncAfter(deadline: .now() + self.waitTime) {
                self.stopLoading()
                self.present(self.alert, animated: true, completion: nil)
            }
        }
    }
    
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // くるくる開始
    func startLoading() {
        view.addSubview(loadingView)
        self.loadingView.play()
    }
    
    // くるくるteisi
    func stopLoading() {
        self.loadingView.removeFromSuperview()
    }
}

extension HomeSellViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 13), height: (collectionView.bounds.width) / 2 )
    }
}

