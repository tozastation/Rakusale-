//
//  ShopVegetables.swift
//  Rakusale
//
//  Created by 戸澤涼 on 2019/02/05.
//  Copyright © 2019 Ryo.Tozawa. All rights reserved.
//

import Foundation
import AlamofireImage
import Alamofire

class ShopVegetablesViewController: UIViewController, UICollectionViewDataSource
{
    
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopAddressLabel: UILabel!
    @IBOutlet weak var shopIntroText: UITextView!
    @IBOutlet weak var shopFavButton: UIButton!
    @IBOutlet weak var vegetableNameLabel: UILabel!
    @IBOutlet weak var vegetableIntroText: UITextView!
    @IBOutlet weak var vegetableAmountLabel: UILabel!
    @IBOutlet weak var vegetableValueLabel: UILabel!
    @IBOutlet weak var vegetableImage: UIImageView!
    
    var vegetables: [ResponseVegetable] = []
    let imageCache = AutoPurgingImageCache()
    
    lazy var loadingView: LOTAnimationView = {
        let animationView = LOTAnimationView(name: "glow_loading")
        animationView.frame = CGRect(x: 0, y: 0, width: (self.view.bounds.width)/2, height: (self.view.bounds.height)/2)
        animationView.center = self.view.center
        animationView.loopAnimation = true
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        
        return animationView
    }()
    
    init(shop: ResponseShop) {
        shopNameLabel.text = shop.name
        let location: CLLocation = CLLocation(latitude: shop.latitude, longitude: shop.longitude)
        shopAddressLabel.text = LocationService.sharedManager.ReverseGeocoder(location: location)
        shopIntroText.text = shop.introduction
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let vegetable: ResponseVegetable = self.vegetables[indexPath.row]
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let imageView = cell.contentView.viewWithTag(5) as! UIImageView
        let url: String = vegetable.imagePath
        if let image = imageCache.image(withIdentifier: url){
            vegetableImage.image = image
        } else {
            Alamofire.request(url).responseImage { response in
                if let image = response.result.value {
                    vegetableImage.image = image
                    self.imageCache.add(image, withIdentifier: url)
                } else {
                    vegetableImage.image = self.imageNotFound
                }
            }
        }
        let nameLabel = cell.contentView.viewWithTag(1) as! UILabel
        nameLabel.text = shop.name
        nameLabel.sizeToFit()
        let intro = cell.contentView.viewWithTag(2) as! UIImageView
        intro.sizeToFit()
        let amountLabel = cell.contentView.viewWithTag(3) as! UILabel
        amountLabel.sizeToFit()
        let valueLabel = cell.contentView.viewWithTag(4) as! UILabel
        valueLabel.sizeToFit()
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vegetables.count
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
