//
//  SettingsProfileViewController.swift
//  Rakusale-iOS
//
//  Created by 赤間 悠大 on 2018/11/18.
//  Copyright © 2018年 Ryo.Tozawa. All rights reserved.
//

import UIKit

class SettingsProfileViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UITextField!
    @IBOutlet weak var introductionLabel: UILabel!
    
    var ActivityIndicator: UIActivityIndicatorView!
    var userID = 0;
    var name: String!
    var introduction: String!
    var imagePath = ""
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileName.delegate = self
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        ActivityIndicator.center = self.view.center
        ActivityIndicator.hidesWhenStopped = true
        ActivityIndicator.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(ActivityIndicator)
    }
    
    // MARK: - Table view data source
    @IBAction func didTapCameraButton(_ sender: Any) {
        let alertController = UIAlertController(title: "画像", message: "選択してください", preferredStyle: .actionSheet)
        //カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            //カメラ起動
            let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler: { (action:UIAlertAction) in
                print("カメラは利用できます")
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        //フォトライブラリが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            //フォトライブラリー起動
            let galleryAction = UIAlertAction(title: "フォトライブラリー", style: .default, handler: {(action:UIAlertAction) in
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            })
            alertController.addAction(galleryAction)
        }
        
        //キャンセル
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.popoverPresentationController?.sourceView = view
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        
        self.name = profileName.text!
        self.introduction = introductionLabel.text!
        let alert: UIAlertController = UIAlertController(title: "保存", message: "保存します。よろしいですか？", preferredStyle:  UIAlertController.Style.alert)
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.postShop()
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let pickedImage = info[.originalImage] as? UIImage{
            profileImage.image = pickedImage
        }
        if info[UIImagePickerController.InfoKey.originalImage] != nil {
            //imageURL = info[UIImagePickerController.InfoKey.imageURL] as? NSURL
            image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else {
            // identifierが取れなかったら処理やめる
            return
        }
        if(identifier == "ncSegue") {
            // NavigationControllerへの遷移の場合
            // segueから遷移先のNavigationControllerを取得
            let nc = segue.destination as! UINavigationController
            let vc = nc.topViewController as! IntroductionViewController
            // 次画面のテキスト表示用のStringに、本画面のテキストフィールドのテキストを入れる
            vc.receiveText = self.introductionLabel.text
        }
    }
    
    
    func postShop() {
//        // くるくる開始
//        self.ActivityIndicator.startAnimating()
//        // 画像データ圧縮
//        let imageData = self.image?.jpegData(compressionQuality: 0.0)
//        // Requestインスタンスを生成
//        var request = URLRequest(url: URL(string: SHOPS_PROFILE_REST)!)
//        // HTTP Methodはポスト
//        request.httpMethod = HTTPMethod.post.rawValue
//        // ぶち込む
//        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
//        // 送信
//        request.setValue(S.getKeychain(Keychain_Keys.Token)!, forHTTPHeaderField: "Authorization")
//        print(S.getKeychain(Keychain_Keys.Token)!)
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            multipartFormData.append(self.name.data(using: .utf8)!, withName: "Name")
//            multipartFormData.append(self.introduction.data(using: .utf8)!, withName: "Introduction")
//            print(multipartFormData)
//        }, with: request) { (encodingResult) in
//            switch encodingResult {
//            case .success(let upload, _, _):
//                upload.responseJSON { response in // ← JSON形式で受け取る
//                    if response.result.isSuccess {
//                        if let data = response.data {
//                            print(response)
//                            // 受け取ったJSONデータをResponseShopにマッピング
//                            let result = try? JSONDecoder().decode(ResponseShop.self, from: data)
//                            if(result != nil && imageData != nil){
//                                // ResponseのIDをファイル名とする
//                                let fileName = String(result!.id) + ".jpg"
//                                // Imageをアップロードするためのパスを設定
//                                let url = SHOPS_IMAGE
//                                // Upload処理 Status Code 200が返ってきたらページ遷移
//                                Alamofire.upload(multipartFormData: { (multipartFormData) in
//                                    multipartFormData.append(imageData!, withName: "image", fileName: fileName, mimeType: "image/png")
//                                }, to: url) { (encodingResult) in
//                                    switch encodingResult {
//                                    case .success(let upload, _, _):
//                                        upload.responseJSON { response in
//                                            if response.result.isSuccess {
//                                                let alert: UIAlertController = UIAlertController(title: "保存完了", message: "保存が完了しました。", preferredStyle:  UIAlertController.Style.alert)
//                                                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
//                                                    // ボタンが押された時の処理を書く（クロージャ実装）
//                                                    (action: UIAlertAction!) -> Void in
//                                                    self.navigationController?.popViewController(animated: true)
//                                                })
//                                                alert.addAction(defaultAction)
//                                                self.present(alert, animated: true, completion: nil)
//                                            } else {
//                                                let alert: UIAlertController = UIAlertController(title: "保存失敗", message: "保存に失敗しました。", preferredStyle:  UIAlertController.Style.alert)
//                                                let failedAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
//                                                    (action: UIAlertAction!) -> Void in
//                                                })
//                                                alert.addAction(failedAction)
//                                                self.present(alert, animated: true, completion: nil)
//                                            }
//                                        }
//                                    case .failure(let encodingError):
//                                        print(encodingError)
//                                        let alert: UIAlertController = UIAlertController(title: "保存失敗", message: "保存に失敗しました。", preferredStyle:  UIAlertController.Style.alert)
//                                        let failedAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
//                                            (action: UIAlertAction!) -> Void in
//                                        })
//                                        alert.addAction(failedAction)
//                                        self.present(alert, animated: true, completion: nil)
//                                    }
//                                }
//                            } else {
//                                let alertEmpty: UIAlertController = UIAlertController(title: "Empty Data", message: "Not Enough Word", preferredStyle:  .alert)
//                                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default)
//                                alertEmpty.addAction(defaultAction)
//                                self.ActivityIndicator.stopAnimating()
//                                self.present(alertEmpty, animated: true, completion: nil)
//                            }
//                        } else {
//                            print("Can't Send to Server")
//                        }
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
    }
}

