//
//  SignUpViewController.swift
//  Rakusale-iOS
//
//  Created by 赤間 悠大 on 2018/10/17.
//  Copyright © 2018年 Ryo.Tozawa. All rights reserved.
//

import UIKit
import Lottie
import PromiseKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userConfirmPassword: UITextField!
    
    let waitTime: Double = 2.0
    lazy var loadingView: LOTAnimationView = {
        let animationView = LOTAnimationView(name: "loading_")
        animationView.frame = CGRect(x: 0, y: 0, width: (self.view.bounds.width)/2, height: (self.view.bounds.height)/2)
        animationView.center = self.view.center
        animationView.loopAnimation = true
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        
        return animationView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.delegate = self
        userEmail.delegate = self
        userPassword.delegate = self
        userConfirmPassword.delegate = self
        userPassword.isSecureTextEntry = true
        userConfirmPassword.isSecureTextEntry = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    @IBAction func didTapPushButton(_ sender: UIButton) {
        let name: String? = userName.text
        let email: String? = userEmail.text
        let password: String? = userPassword.text
        let rePassword: String? = userConfirmPassword.text
        
        // Case Invailed User Name
        if name == "" {
            let alert: UIAlertController = UIAlertController (title: "名前が入力されていません", message: "名前を入力してください。", preferredStyle: .alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }
        // Case Invailed email
        else if email == "" {
            let alert: UIAlertController = UIAlertController (title: "メールアドレスが入力されていません", message: "メールアドレスを入力してください。", preferredStyle: .alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }
        // Case Invailed password
        else if password == "" {
            let alert: UIAlertController = UIAlertController (title: "パスワードが入力されていません", message: "パスワードを入力してください。", preferredStyle: .alert)
            //okボタン
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }
        // Case Invailed confirm_password
        else if (password != rePassword) && (password != "" && rePassword == "") {
            let alert: UIAlertController = UIAlertController (title: "パスワードが一致しません", message: "もう一度パスワードを入力してください。", preferredStyle: .alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }
        else{
            let alert: UIAlertController = UIAlertController(title: "登録確認", message: "この情報で登録します。よろしいですか？", preferredStyle: .alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style:.default, handler:{
                (action: UIAlertAction!) -> Void in
                self.regist(name: name!, email: email!, password: password!)
            })
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel)
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func regist(name: String, email: String, password: String){
        self.startLoading()
        // Start Loading Animation
        self.startLoading()
        // Call RPC
        print("Activate Login")
        firstly {
            EntryClient.shared.signUp(name: name, email: email, password: password)
        }.done { token in
            print("[Your Token]")
            print(token)
            S.setKeychain(Keychain_Keys.Token, token)
            //ログイン状態 Change to True
            S.login()
            print("[Your Account State]")
            print(S.loadLoginState())
            DispatchQueue.main.asyncAfter(deadline: .now() + self.waitTime) {
                self.stopLoading()
                self.navigationController?.popViewController(animated: true)
            }
        }.catch {e in
            print(e)
            self.stopLoading()
            let alert: UIAlertController = UIAlertController (title: "送信に失敗しました。", message: "再度入力して下さい", preferredStyle: .alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
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
