//
//  SellSettingsViewController.swift
//  Rakusale-iOS
//
//  Created by 赤間 悠大 on 2018/11/17.
//  Copyright © 2018年 Ryo.Tozawa. All rights reserved.
//

import UIKit

class SellSettingsViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func didTapSignOutButton(_ sender: Any) {
        S.logout()
    }
}
