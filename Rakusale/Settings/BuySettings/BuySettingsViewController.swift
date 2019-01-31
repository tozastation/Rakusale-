//
//  SettingsViewController.swift
//  Rakusale-iOS
//
//  Created by 赤間 悠大 on 2018/11/11.
//  Copyright © 2018年 Ryo.Tozawa. All rights reserved.
//

import UIKit

class BuySettingsViewController: UITableViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
