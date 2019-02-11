//
//  ShopRegistrationVC.swift
//  Rakusale
//
//  Created by 戸澤涼 on 2019/02/11.
//  Copyright © 2019 Ryo.Tozawa. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import PromiseKit
import SCLAlertView

class ShopRegistrationVC: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var shopImageView: UIImageView!
    @IBOutlet weak var shopNameTextField: UITextField!
    @IBOutlet weak var shopIntroTextField: UITextField!
    @IBOutlet weak var shopPostalTextField: UITextField!
    @IBOutlet weak var shopPrefectureTextField: UITextField!
    @IBOutlet weak var shopCityTextField: UITextField!
    @IBOutlet weak var shopOtherTextField: UITextField!
    
    var image: UIImage?
    var disposeBag = DisposeBag()
    
    private var shopName = Variable<String>("未来大農場(Fun Form)")
    private var shopIntro = Variable<String>("公立はこだて未来大学の学生が育てている特別な野菜です！")
    private var shopPostal = Variable<String>("041-8655")
    private var shopPrefecture = Variable<String>("北海道")
    private var shopCity = Variable<String>("函館市亀田中野町")
    private var shopOther = Variable<String>("116番地2")
    
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
        self.setup()
        self.shopNameTextField.delegate = self
        self.shopIntroTextField.delegate = self
        self.shopPostalTextField.delegate = self
        self.shopPrefectureTextField.delegate = self
        self.shopCityTextField.delegate = self
        self.shopOtherTextField.delegate = self
    }
    
    @IBAction func didTapCameraButton(_ sender: Any) {
        let alertController = UIAlertController(title: "画像", message: "選択してください", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler: { (action:UIAlertAction) in
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                self.present(imagePickerController, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let galleryAction = UIAlertAction(title: "フォトライブラリー", style: .default, handler: {(action:UIAlertAction) in
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                self.present(imagePickerController, animated: true, completion: nil)
            })
            alertController.addAction(galleryAction)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.popoverPresentationController?.sourceView = view
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let pickedImage = info[.originalImage] as? UIImage{
            self.shopImageView.image = pickedImage
        }
        if info[UIImagePickerController.InfoKey.originalImage] != nil {
            self.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func startLoading() {
        view.addSubview(loadingView)
        loadingView.play()
    }
    
    func stopLoading() {
        self.loadingView.removeFromSuperview()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func tapRequestLocationButton(_ sender: Any) {
        let alertView = SCLAlertView()
        alertView.addButton("登録する") {
            self.addShop(latitude: Float(LocationService.sharedManager.latitude), longitude: Float(LocationService.sharedManager.longitude))
        }
        alertView.addButton("Cancel") {
            self.dismiss(animated: true, completion: nil)
        }
        alertView.showSuccess("確認画面", subTitle: "緯度: " + String(LocationService.sharedManager.latitude) + "\n" + "経度: " + String(LocationService.sharedManager.longitude))
    }
    
    @IBAction func tapReturnButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addShop(latitude: Float, longitude: Float) {
        LogService.shared.logger.info("[START] Call buyVegetables")
        let name = shopName.value
        let intro = shopIntro.value
        let token = S.getKeychain(Keychain_Keys.Token)!
        let imageData = self.image?.jpegData(compressionQuality: 0.0)
        // Start Loading Animation
        self.startLoading()
        // Call RPC
        firstly {
            ShopClient.shared.postMyShop(
                name: name,
                latitude: latitude,
                longitude: longitude,
                intro: intro,
                data: imageData!,
                token: token
            )
            }.done { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.stopLoading()
                    self.dismiss(animated: true, completion: nil)
                }
            }.catch { e in
                LogService.shared.logger.error("[EXECUTE FAILURE!] on Calling buyVegetablesRPC")
                LogService.shared.logger.error("[Detail]" + e.localizedDescription)
                LogService.shared.logger.error("Present Alert Message")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.stopLoading()
                    SCLAlertView().showError("Failed", subTitle: "購入を完了できませんでした") // Error
                }
        }
        LogService.shared.logger.info("[END] Call buyVegetables")
    }
    
    private func setup() {
        self.shopName.asObservable().bind(to: shopNameTextField.rx.text).disposed(by: disposeBag)
        self.shopIntro.asObservable().bind(to: shopIntroTextField.rx.text).disposed(by: disposeBag)
        self.shopPostal.asObservable().bind(to: shopPostalTextField.rx.text).disposed(by: disposeBag)
        self.shopPrefecture.asObservable().bind(to: shopPrefectureTextField.rx.text).disposed(by: disposeBag)
        self.shopCity.asObservable().bind(to: shopCityTextField.rx.text).disposed(by: disposeBag)
        self.shopOther.asObservable().bind(to: shopOtherTextField.rx.text).disposed(by: disposeBag)
    }
}
