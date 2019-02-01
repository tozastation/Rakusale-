//
//  SignInViewController.swift
//  Rakusale-iOS
//
//  Created by 赤間 悠大 on 2018/10/17.
//  Copyright © 2018年 Ryo.Tozawa. All rights reserved.
//

import UIKit
import Lottie
import RxSwift
import RxCocoa
import PromiseKit
import Alamofire

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
        // Initialize
        id.delegate = self
        password.delegate = self
        password.isSecureTextEntry = true
        // 利用許諾
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
        // [ログイン] 入力した値に何もなかったら、遷移しない
        if(idText != "" && passText != "") {
            self.login(email: idText!, password: passText!)
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
    
    /*ロジック部分*/
    func login(email: String, password: String) {
        // Start Loading Animation
        self.startLoading()
        // Call RPC
        print("Activate Login")
        firstly {
            EntryClient.shared.signIn(email: email, password: password)
        }.done { token in
            print("[Your Token]")
            print(token)
            S.setKeychain(Keychain_Keys.Token, token)
            S.login() //ログイン状態 Change to True
            print(S.loadLoginState())
            DispatchQueue.main.asyncAfter(deadline: .now() + self.waitTime) {
                self.stopLoading()
                self.userSelect?.isHidden = false
            }
        }.catch {e in
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
    
    // くるくるteisi
    func stopLoading() {
        self.loadingView.removeFromSuperview()
    }
}
