//
//  ViewController.swift
//  thrid_login_native
//
//  Created by zhengzeqin on 2022/8/29.
//

import UIKit
import LineSDK
import GoogleSignIn
import FBSDKLoginKit

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(
            forName: .ProfileDidChange,
            object: nil,
            queue: .main
        ) { notification in
            if let currentProfile = Profile.current {
                print("userID:\(currentProfile.userID) name: \(currentProfile.name ?? "")")
            }
        }
    }
    
    /// 登录 line
    @IBAction func lineAction(_ sender: UIButton) {
        LoginManager.shared.login(permissions: [.profile], in: self) { result in
            switch result {
            case .success(let loginResult):
                if let profile = loginResult.userProfile {
                   print("User ID: \(profile.userID)")
                   print("User Display Name: \(profile.displayName)")
                   print("User Icon: \(String(describing: profile.pictureURL))")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// 登出 line
    func lineLoginOutAction()  {
        LoginManager.shared.logout { (result) in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let error):
                print(error)
            }
        }
    }
    

    /// 谷歌登录
    @IBAction func googleAction(_ sender: UIButton) {
        /// 用户端编号
        let signInConfig = GIDConfiguration(clientID: "xxxxxxxxxxx-xxxxxxxxxxxxxxxxxx.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            guard let _user = user else { return }
            if let userId = _user.userID {
                print("User ID: \(userId)")
            }
            if let profile = _user.profile {
               print("User Display Name: \(profile.name)")
            }
        }
    }
    
    /// 登出 google
    func googleLoginOutAction()  {
        GIDSignIn.sharedInstance.signOut();
    }
    
    /// facebook 登录
    @IBAction func facebookAction(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile"], from: self) { result, error in
            if let error = error {
                print("Encountered Erorr: \(error)")
            } else if let result = result, result.isCancelled {
                print("Cancelled")
            } else {
                print("Logged In")
                if let userID = result?.token?.userID  {
                    print("userID: ===> \(userID)")
                }
                if let tokenString = result?.token?.tokenString  {
                    print("tokenString: ===> \(tokenString)")
                }
            }
        }
    }
    
    /// 登出 facebook
    func facebookLoginOutAction()  {
        let loginManager = LoginManager()
        loginManager.logOut()
    }
    
}


