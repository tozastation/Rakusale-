//
//  SettingsAdressViewController.swift
//  Rakusale-iOS
//
//  Created by 赤間 悠大 on 2018/11/18.
//  Copyright © 2018年 Ryo.Tozawa. All rights reserved.
//

import UIKit

class SettingsAdressViewController: UIViewController {
    @IBOutlet weak var userAdress: UILabel!
    @IBOutlet weak var resultView: UIView!
    

    var ActivityIndicator: UIActivityIndicatorView!
    
    var userID = 0;
    var imagePath = ""
    var name = ""
    var introduction = ""
    var latitude: String!
    var longitude: String!
    var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        ActivityIndicator.center = self.view.center
        ActivityIndicator.hidesWhenStopped = true
        ActivityIndicator.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(ActivityIndicator)
    }

    @IBAction func didTapSaveButton(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: "保存", message: "保存します。よろしいですか？", preferredStyle:  UIAlertController.Style.alert)
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.postShopAddress(latitude: self.latitude,longitude: self.longitude)
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
    
    func postShopAddress(latitude: String, longitude: String) {
//        // くるくる開始
//        self.ActivityIndicator.startAnimating()
//        // Requestインスタンスを生成
//        var request = URLRequest(url: URL(string: SHOPS_ADDRESS_REST)!)
//        // HTTP Methodはポスト
//        request.httpMethod = HTTPMethod.post.rawValue
//        // ぶち込む
//        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
//        // 送信
//        request.setValue(S.getKeychain(Keychain_Keys.Token), forHTTPHeaderField: "Authorization")
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            multipartFormData.append(latitude.data(using: .utf8)!, withName: "Latitude")
//            multipartFormData.append(longitude.data(using: .utf8)!, withName: "Longitude")
//        }, with: request) { (encodingResult) in
//            switch encodingResult {
//            case .success(let upload, _, _):
//                upload.responseJSON { response in // ← JSON形式で受け取る
//                    if response.result.isSuccess {
//                       let alert: UIAlertController = UIAlertController(title: "保存完了", message: "保存が完了しました。", preferredStyle:  UIAlertController.Style.alert)
//                        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
//                            // ボタンが押された時の処理を書く（クロージャ実装）
//                            (action: UIAlertAction!) -> Void in
//                            self.navigationController?.popViewController(animated: true)
//                        })
//                        alert.addAction(defaultAction)
//                        self.present(alert, animated: true, completion: nil)
//                    } else {
//                        let alert: UIAlertController = UIAlertController(title: "保存失敗", message: "保存に失敗しました。", preferredStyle:  UIAlertController.Style.alert)
//                        let failedAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
//                            (action: UIAlertAction!) -> Void in
//                        })
//                        alert.addAction(failedAction)
//                        self.present(alert, animated: true, completion: nil)
//                    }
//                }
//            case .failure(let encodingError):
//                print(encodingError)
//                let alert: UIAlertController = UIAlertController(title: "保存失敗", message: "保存に失敗しました。", preferredStyle:  UIAlertController.Style.alert)
//                let failedAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
//                    (action: UIAlertAction!) -> Void in
//                })
//                alert.addAction(failedAction)
//                self.present(alert, animated: true, completion: nil)
//            }
//        }
//        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func resultAction(_ address: String, latitude: String, longitude: String){
        self.userAdress.text = address
        self.resultView.isHidden = false
        self.latitude = latitude
        self.longitude = longitude
    }
}

