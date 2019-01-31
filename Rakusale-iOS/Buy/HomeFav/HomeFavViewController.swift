//
//  HomeFavViewController.swift
//  Rakusale-iOS
//
//  Created by 赤間 悠大 on 2018/10/19.
//  Copyright © 2018年 Ryo.Tozawa. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class HomeFavViewController: UIViewController {

    @IBOutlet weak var uiCollectionView: UICollectionView!
    var shops : [ResponseShop] = []
    fileprivate let refreshCtl = UIRefreshControl()
    let imageCache = AutoPurgingImageCache()
    let imageNotFound = UIImage(named: "404")
    
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
        let shop: ResponseShop = self.shops[indexPath.row]
        // Identifer振ってるやつのインスタンス生成
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "Cell",
            for: indexPath
        )
        // 画像データ取得
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        let url: String = shop.imagePath
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
        var request = URLRequest(url: URL(string:SHOPS_PROFILE_REST)!)
        request.httpMethod = HTTPMethod.get.rawValue
        Alamofire.request(request).responseJSON {
            response in
            if response.result.isSuccess {
                if let data = response.data {
                    self.shops = try! JSONDecoder().decode([ResponseShop].self, from: data)
                    //print(response)
                    self.uiCollectionView.reloadData()
                }
            }else{
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension HomeFavViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 13) / 4, height: (collectionView.bounds.width - 13) / 4)
    }
}

