//
//  SignInViewController.swift
//  Rakusale-iOS
//
//  Created by 赤間 悠大 on 2018/10/17.
//  Copyright © 2018年 Ryo.Tozawa. All rights reserved.
//

import UIKit
import Alamofire
import Lottie
import RxSwift
import RxCocoa

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var userSelect: UIView!
    
    let alert: UIAlertController = UIAlertController(title: "Invaild Login", message: "Please Retype", preferredStyle:  .alert)
    let actionChoise = UIAlertAction(title: "Confirm", style: .default)
    
    let waitTime: Double = 2.0
    
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
        id.delegate = self
        password.delegate = self
        password.isSecureTextEntry = true
        self.alert.addAction(self.actionChoise)
        LocationService.sharedManager.checkLocationAuthentication() //位置情報の確認ダイアログを出す
        LocalNotificationService.sharedManager.checkPushAuthorization()
        RealmService.sharedManager.insertShops()
        print(RealmService.sharedManager.getRealmPath())
        // 初回起動時に遷移する画面を振り分け
        NotificationCenter.default.rx
            .notification(UIApplication.didBecomeActiveNotification)
            .subscribe(onNext: { (notification) in
                if S.loadLoginState() {
                    self.userSelect?.isHidden = false
                }else{
                    self.userSelect?.isHidden = true
                }
        })
        .disposed(by: DisposeBag())
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        if S.loadLoginState() {
            self.userSelect?.isHidden = false
        }else{
            self.userSelect?.isHidden = true
        }
    }
   
    @IBAction func didTapLogInButton(_ sender: Any) {
        let idText: String? = id.text
        let passText: String? = password.text
        if(idText != "" && passText != "") {
            self.login(email: idText!, pass: passText!)
        }else{
            self.present(self.alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapSignUpButton(_ sender: Any) {
        self.navigationController?.pushViewController(SignUpViewController.create(), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func login(email: String, pass: String) {
        self.startLoading()
        var request = URLRequest(url: URL(string: LOGIN_PATH)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        // Headerに認証に必要なデータを掲載
        request.setValue(email, forHTTPHeaderField: "Email")
        request.setValue(pass, forHTTPHeaderField: "Password")
        request.timeoutInterval = 5.0
        Alamofire.request(request).responseJSON {
            response in
            if response.result.isSuccess {
                if let data = response.data {
                    print(response)
                    let auth = try? JSONDecoder().decode(ResponseAuth.self, from: data)
                    // KeyChainにTokenを保存
                    S.setKeychain(Keychain_Keys.Token, auth?.accessToken)
                    // UserDefaultにログイン状態を保持
                    S.login()
                    print(S.loadLoginState())
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.waitTime) {
                        self.stopLoading()
                        self.userSelect?.isHidden = false
                    }
                }
            }else {
                DispatchQueue.main.asyncAfter(deadline: .now() + self.waitTime) {
                    self.stopLoading()
                    self.present(self.alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // くるくる開始
    func startLoading() {
        view.addSubview(loadingView)
        loadingView.play()
    }
    
    // くるくるteisi
    func stopLoading() {
        self.loadingView.removeFromSuperview()
    }
}
