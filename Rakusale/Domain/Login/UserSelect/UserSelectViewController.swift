//
//  UserSelectViewController.swift
//  Rakusale-iOS
//
//  Created by 赤間 悠大 on 2018/10/17.
//  Copyright © 2018年 Ryo.Tozawa. All rights reserved.
//

import UIKit

class UserSelectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapBuyButton(_ sender: Any) {
        self.navigationController?.pushViewController(HomeShopViewController.create(), animated: true)
    }
    
    @IBAction func didTapSellButton(_ sender: Any) {
        self.navigationController?.pushViewController(HomeSellViewController.create(), animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
