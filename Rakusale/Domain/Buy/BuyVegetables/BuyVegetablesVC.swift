//
//  BuyVegetableVC.swift
//  Rakusale
//
//  Created by 戸澤涼 on 2019/02/10.
//  Copyright © 2019 Ryo.Tozawa. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Kingfisher
import PromiseKit
import SCLAlertView

class BuyVegetablesVC: UIViewController {
    
    @IBOutlet weak var vegetableNameLabel: UILabel!
    @IBOutlet weak var vegetableAmountLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var upperButton: UIButton!
    @IBOutlet weak var lowerButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    let imageNotFound = UIImage(named: "404")
    var disposeBag = DisposeBag()
    private var amount = Variable<String>("0")
    private var counter = 0
    var recieveVegetable: Vegetable_ResponseVegetable!
    
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
        self.vegetableNameLabel.text = SharedService.shared.segueVegetable.name
        self.setup()
        if SharedService.shared.segueVegetable.imagePath != "" {
            imageView.kf.setImage(with: ImageResource(downloadURL: URL(string: SharedService.shared.segueVegetable.imagePath)!))
        } else {
            imageView.image = self.imageNotFound
        }
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        buyButton.layer.cornerRadius = 5.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onTapCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapUpper(_ sender: UIButton) {
        counter = counter + 1
        amount.value = String(counter)
    }
    
    @IBAction func onTapLower(_ sender: UIButton) {
        counter = counter - 1
        amount.value = String(counter)
    }
    
    @IBAction func onTapBuy(_ sender: UIButton) {
        let alertView = SCLAlertView()
        alertView.addButton("購入する") {
            self.dismiss(animated: true, completion: nil)
        }
        alertView.showSuccess("購入確定", subTitle: SharedService.shared.segueVegetable.name + "を" + amount.value + "個")
    }
    
    private func setup() {
        amount.asObservable().bind(to: vegetableAmountLabel.rx.text).disposed(by: disposeBag)
    }
    
    func buyVegetables(shopID: Int64) {
        LogService.shared.logger.info("[START] Call loadShops")
        // Start Loading Animation
        self.startLoading()
        // Call RPC
        firstly {
            VegetableClient.shared.getSingleShopAllVegetables(shopID: shopID)
            }.done { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.stopLoading()
                    self.dismiss(animated: false, completion: nil)
                }
            }.catch { e in
                LogService.shared.logger.error("[EXECUTE FAILURE!] on Calling getAllShopRPC")
                LogService.shared.logger.error("[Detail]" + e.localizedDescription)
                LogService.shared.logger.error("Present Alert Message")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.stopLoading()
                    //self.present(self.alert, animated: true, completion: nil)
                }
        }
        LogService.shared.logger.info("[END] Call loadShops")
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
