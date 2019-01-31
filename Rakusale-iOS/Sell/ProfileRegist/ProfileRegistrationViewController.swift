//
//  ProfileRegistrationViewController.swift
//  Rakusale-iOS
//
//  Created by 赤間 悠大 on 2018/10/19.
//  Copyright © 2018年 Ryo.Tozawa. All rights reserved.
//

import UIKit
import Alamofire

class ProfileRegistrationViewController: UITableViewController,UITextFieldDelegate,UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UITextField!
    @IBOutlet weak var profileMessage: UITextView!
    @IBOutlet weak var profilePostCode: UITextField!
    @IBOutlet weak var profileState: UITextField!
    @IBOutlet weak var profileCity: UITextField!
    @IBOutlet weak var profileAddress: UITextField!
    
    var userID: Int = 0
    var imagePath: String = ""
    var name: String = ""
    var latitude: String = ""
    var longitude: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileName.delegate = self
        profileMessage.delegate = self
        profilePostCode.delegate = self
        profileState.delegate = self
        profileCity.delegate = self
        profileAddress.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    @IBAction func didTapDecideButton(_ sender: Any) {
        self.name = profileName.text ?? ""
        //未来大(仮)
        self.longitude = "41.841817"
        //未来大(仮)
        self.latitude = "140.766969"
        //アラートメッセージ
        let alert: UIAlertController = UIAlertController(title: "登録確認", message: "この情報で登録します。よろしいですか？", preferredStyle:  UIAlertController.Style.alert)
        //OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            //ポスト処理
//            let inputShop = RequestShop (
//                userID: self.userID,
//                imagePath: self.imagePath,
//                name: self.name,
//                latitude: self.latitude,
//                longitude: self.longitude
//            )
//            let strEndPoint: String = serverIP + ENDPOINT["POST_USER"]!
//            let url = URL(string: strEndPoint)!
//            self.postShop(endPoint: url, data: inputShop)
            //画面遷移
            self.navigationController?.popToRootViewController(animated: true)
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
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    func postShop(endPoint: URL!, data: RequestShop) {
//        let encoder = JSONEncoder()
//        let jsonData = try? encoder.encode(data)
//        var request = URLRequest(url: endPoint)
//        request.httpMethod = HTTPMethod.post.rawValue
//        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonData
//        Alamofire.request(request).responseJSON {
//            response in
//            if let json = response.result.value {
//                print("JSON: \(json)") // serialized json response
//            }else {
//                print("Can't Send to Server")
//            }
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
