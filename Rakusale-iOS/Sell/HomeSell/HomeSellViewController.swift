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

class HomeSellViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var uiCollectionView: UICollectionView!
    var vegetables : [ResponseVegetable] = []
    fileprivate let refreshCtl = UIRefreshControl()
    let imageCache = AutoPurgingImageCache()
    let imageNotFound = UIImage(named: "404")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        self.uiCollectionView.delegate = self
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
        let vegetable: ResponseVegetable = self.vegetables[indexPath.row]
        // Identifer振ってるやつのインスタンス生成
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "Cell",
            for: indexPath
        )
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
        var request = URLRequest(url: URL(string:VEGETABLE_MINE)!)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue(S.getKeychain(Keychain_Keys.Token)!, forHTTPHeaderField: "Authorization")
        Alamofire.request(request).responseJSON {
            response in
            if response.result.isSuccess {
                if let data = response.data {
                    self.vegetables = try! JSONDecoder().decode([ResponseVegetable].self, from: data)
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

extension HomeSellViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 13) / 2, height: (collectionView.bounds.width - 13) / 2)
    }
}

