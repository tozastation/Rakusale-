//
//  ProfileMessageViewController.swift
//  Rakusale-iOS
//
//  Created by 赤間 悠大 on 2018/11/23.
//  Copyright © 2018年 Ryo.Tozawa. All rights reserved.
//

import UIKit

class IntroductionViewController: UIViewController ,UITextViewDelegate{
    @IBOutlet weak var introduction: UITextView!
    var receiveText:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        introduction.delegate = self
        self.introduction.text = receiveText
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSaveMessageButton(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "保存", message: "保存します。よろしいですか？", preferredStyle:  UIAlertController.Style.alert)
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            if self.presentingViewController is UINavigationController {
                let nc = self.presentingViewController as! UINavigationController
                
                // 前画面のViewControllerを取得
                let vc = nc.topViewController as! SettingsProfileViewController
                
                // 前画面のViewControllerの値を更新
                vc.introductionLabel.text = self.introduction.text
                self.dismiss(animated: true, completion: nil)
            }
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
        })
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            //あなたのテキストフィールド
            introduction.resignFirstResponder()
            return false
        }
        return true
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
