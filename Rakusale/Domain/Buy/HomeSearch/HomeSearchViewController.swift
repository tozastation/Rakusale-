//
//  HomeSearchViewController.swift
//  Rakusale-iOS
//
//  Created by 赤間 悠大 on 2018/10/19.
//  Copyright © 2018年 Ryo.Tozawa. All rights reserved.
//

import UIKit

class HomeSearchViewController: UIViewController {

    @IBOutlet weak var shopInformation: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shopInformation.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ShopInformation() {
        self.shopInformation.isHidden = false
    }
    

}
