//
//  RegistrationViewController.swift
//  Rakusale-iOS
//
//  Created by 赤間 悠大 on 2018/10/17.
//  Copyright © 2018年 Ryo.Tozawa. All rights reserved.
//

import UIKit
import PromiseKit

class RegistrationViewController: UITableViewController,UITextFieldDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
   
    @IBOutlet weak var vegetableImage: UIImageView!
    @IBOutlet weak var vegetableName: UITextField!
    @IBOutlet weak var vegetableValue: UITextField!
    @IBOutlet weak var vegetableNumber: UITextField!
    @IBOutlet weak var vegetableDeadline: UITextField!
    @IBOutlet weak var vegetablePrice: UITextField!
    @IBOutlet weak var vegetableCommision: UITextField!
    
    var ActivityIndicator: UIActivityIndicatorView!
    
    let waitTime: Double = 0.2
    var shopID = 0
    var name = ""
    var fee : Int64 = 0
    var isChemical = false
    var imagePath = ""
    var productionDate = ""
    
    let valueToolbar: UIToolbar = UIToolbar()
    let numberToolbar: UIToolbar = UIToolbar()
    var image: UIImage?
    var pickerView: UIPickerView = UIPickerView()
    let alert: UIAlertController = UIAlertController(title: "Invaild Regist", message: "Please Retype", preferredStyle:  .alert)
    lazy var loadingView: LOTAnimationView = {
        let animationView = LOTAnimationView(name: "glow_loading")
        animationView.frame = CGRect(x: 0, y: 0, width: (self.view.bounds.width)/2, height: (self.view.bounds.height)/2)
        animationView.center = self.view.center
        animationView.loopAnimation = true
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        
        return animationView
    }()
    
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
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        pickerView.delegate = self
        vegetableName.inputView = pickerView
        vegetableName.inputAccessoryView = toolbar
        
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
            
            if self.name != "" {
                self.postVegetable(name: self.name, fee: self.fee, isChemical: self.isChemical, productionDate: self.productionDate)
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return EnumService.shared.vegetableOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return EnumService.shared.vegetableOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        vegetableName.text = EnumService.shared.vegetableOption[row]
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
    
    @objc func done() {
        vegetableName.endEditing(true)
    }
    
    // 入力されたデータを送信する処理
    func postVegetable(name: String, fee: Int64, isChemical: Bool, productionDate: String) {
        // くるくる開始
        self.ActivityIndicator.startAnimating()
        // 画像データ圧縮
        let imageData = self.image?.jpegData(compressionQuality: 0.0)
        // Token取得
        let token = S.getKeychain(Keychain_Keys.Token)!
        let category = EnumService.shared.convertEnum(v: self.name)
        firstly {
            VegetableClient.shared.postMyVegetable(token: token, name: name, fee: fee, isChemical: isChemical, productionDate: productionDate, image: imageData!, category: category!)
        }.done { () in
            DispatchQueue.main.asyncAfter(deadline: .now() + self.waitTime) {
                self.stopLoading()
                self.navigationController?.popToRootViewController(animated: true)
            }
        }.catch { e in
            print(e)
            DispatchQueue.main.asyncAfter(deadline: .now() + self.waitTime) {
                self.stopLoading()
                self.present(self.alert, animated: true, completion: nil)
            }
        }
    }
    
    // くるくる開始
    func startLoading() {
        view.addSubview(loadingView)
        loadingView.play()
    }
    
    // くるくる停止
    func stopLoading() {
        self.loadingView.removeFromSuperview()
    }
}
