//
//  RegistrationViewController.swift
//  Rakusale-iOS
//
//  Created by 赤間 悠大 on 2018/10/17.
//  Copyright © 2018年 Ryo.Tozawa. All rights reserved.
//

import UIKit
import Alamofire

class RegistrationViewController: UITableViewController,UITextFieldDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var vegetableImage: UIImageView!
    @IBOutlet weak var vegetableName: UITextField!
    @IBOutlet weak var vegetableValue: UITextField!
    @IBOutlet weak var vegetableNumber: UITextField!
    @IBOutlet weak var vegetableDeadline: UITextField!
    @IBOutlet weak var vegetablePrice: UITextField!
    @IBOutlet weak var vegetableCommision: UITextField!
    
    var ActivityIndicator: UIActivityIndicatorView!
    
    var shopID = 0
    var name = ""
    var fee : Int64 = 0
    var isChemical = false
    var imagePath = ""
    var productionDate = ""
    
    let valueToolbar: UIToolbar = UIToolbar()
    let numberToolbar: UIToolbar = UIToolbar()

    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vegetableName.delegate = self
        vegetableValue.delegate = self
        vegetableValue.keyboardType = UIKeyboardType.numberPad
        vegetableNumber.delegate = self
        vegetableNumber.keyboardType = UIKeyboardType.numberPad
        vegetableDeadline.delegate = self
    
        valueToolbar.items=[
            UIBarButtonItem(title: "キャンセル", style: .done, target: self, action: #selector(self.cancelActionValue)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(self.doneActionValue))
        ]
        
        numberToolbar.items=[
            UIBarButtonItem(title: "キャンセル", style: .done, target: self, action: #selector(self.cancelAction)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(self.doneAction))
        ]
        
        valueToolbar.sizeToFit()
        numberToolbar.sizeToFit()
        
        vegetableValue.inputAccessoryView = valueToolbar
        vegetableNumber.inputAccessoryView = numberToolbar
        
        // ActivityIndicator
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        ActivityIndicator.center = self.view.center
        ActivityIndicator.hidesWhenStopped = true
        ActivityIndicator.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(ActivityIndicator)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 決定ボタンを押した際の処理
    @IBAction func didTapDecisionButton(_ sender: Any) {
        self.name = vegetableName.text ?? ""
        self.fee = Int64(vegetableValue.text!) ?? 0
        self.productionDate = vegetableDeadline.text!
        //アラートメッセージ
        let alert: UIAlertController = UIAlertController(title: "登録確認", message: "この情報で登録します。よろしいですか？", preferredStyle:  UIAlertController.Style.alert)
        //OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            // リクエスト用のモデルを生成
            let inputVagetable = RequestVegetable (
                shopId: self.shopID,
                name: self.name,
                fee: self.fee,
                isChemical: self.isChemical,
                imagePath: self.imagePath,
                productonDate: self.productionDate
            )
            
            if inputVagetable.name != "" {
                self.postVegetable(data: inputVagetable)
            } else {
                let alertEmptyMust: UIAlertController = UIAlertController(title: "Empty Data", message: "Not Enough Word", preferredStyle:  .alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default)
                alertEmptyMust.addAction(defaultAction)
                self.ActivityIndicator.stopAnimating()
                self.present(alertEmptyMust, animated: true, completion: nil)
            }
            
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel)
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    // カメラ起動の処理
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
    
    // カメラやギャラリーから画像イメージを取得後の処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let pickedImage = info[.originalImage] as? UIImage{
            vegetableImage.image = pickedImage
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
    
    @objc func doneActionValue () {
        let comm = Double(vegetableValue.text ?? "") ?? 0
        let price = Int(vegetableValue.text ?? "") ?? 0
        vegetableCommision.text = "¥" + String(Int(ceil(comm / 20)))
        vegetablePrice.text = "¥" + String(price - Int(ceil(comm / 20)))
        vegetableValue.resignFirstResponder()
    }
    
    @objc func cancelActionValue (){
        vegetableValue.text = ""
        vegetableValue.resignFirstResponder()
    }
    
    @objc func doneAction () {
        vegetableNumber.resignFirstResponder()
    }
    
    @objc func cancelAction (){
        vegetableNumber.text = ""
        vegetableNumber.resignFirstResponder()
    }
    
    // 入力されたデータを送信する処理
    func postVegetable(data: RequestVegetable) {
        // くるくる開始
        self.ActivityIndicator.startAnimating()
        // 画像データ圧縮
        let imageData = self.image?.jpegData(compressionQuality: 0.0)
        // responseのインスタンス生成
        var result:ResponseVegetable?
        // JSON Encode用のインスタンス生成
        let encoder = JSONEncoder()
        // RequestVegetableオブジェクトをJSONにパース
        let jsonData = try? encoder.encode(data)
        // Requestインスタンスを生成
        var request = URLRequest(url: URL(string: VEGETABLE_REST)!)
        // HTTP Methodはポスト
        request.httpMethod = HTTPMethod.post.rawValue
        // ぶち込む
        request.setValue(S.getKeychain(Keychain_Keys.Token)!, forHTTPHeaderField: "Authorization")
        // Bodyにパースした野菜のデータを設置
        request.httpBody = jsonData
        // 送信
        
        Alamofire.request(request).responseJSON {
            response in
            if let data = response.data {
                print(response)
                // 受け取ったJSONデータをResponseVegetableにマッピング
                result = try? JSONDecoder().decode(ResponseVegetable.self, from: data)
                if(result != nil && imageData != nil){
                    // ResponseのIDをファイル名とする
                    let fileName = String(result!.id) + ".jpg"
                    // Imageをアップロードするためのパスを設定
                    let url = VEGETABLE_IMAGE
                    // Upload処理 Status Code 200が返ってきたらページ遷移
                    Alamofire.upload(multipartFormData: { (multipartFormData) in
                        multipartFormData.append(imageData!, withName: "image", fileName: fileName, mimeType: "image/png")
                    }, to: url ) { (encodingResult) in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseJSON { response in
                                if !response.result.isSuccess {
                                    print("# ERROR")
                                } else {
                                    print("# SUCCESS")
                                    self.ActivityIndicator.stopAnimating()
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                            }
                        case .failure(let encodingError):
                            print(encodingError)
                        }
                    }
                } else {
                    let alertEmpty: UIAlertController = UIAlertController(title: "Empty Data", message: "Not Enough Word", preferredStyle:  .alert)
                    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default)
                    alertEmpty.addAction(defaultAction)
                    self.ActivityIndicator.stopAnimating()
                    self.present(alertEmpty, animated: true, completion: nil)
                }
            } else {
                print("Can't Send to Server")
            }
        }
    }
}
