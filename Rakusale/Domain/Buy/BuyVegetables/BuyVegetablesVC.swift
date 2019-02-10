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
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onTapUpper(_ sender: UIButton) {
        counter = counter + 1
        amount.value = String(counter)
    }
    
    @IBAction func onTapLower(_ sender: UIButton) {
        counter = counter - 1
        amount.value = String(counter)
    }
    
    private func setup() {
        amount.asObservable().bind(to: vegetableAmountLabel.rx.text).disposed(by: disposeBag)
    }
}
