//
//  SocialLocinViewController.swift
//  App
//
//  Created by PKW on 2023/12/19.
//

import UIKit
import GoogleSignIn

class SocialLoginViewController: UIViewController {

    var viewModel: SocialLoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    // 846233671186-1ri677r59p8slvhu0ph98kg2ir0kuk45.apps.googleusercontent.com
    @IBAction func didTabNextButton(_ sender: Any) {
        viewModel?.coordinator?.showNicknameViewController()
    }
    
    @IBAction func didTabGoogleLoginButton(_ sender: Any) {

        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] signInResult, _ in
            guard let self,
                  let result = signInResult,
                  let idToken = result.user.idToken?.tokenString else { return }
            // 서버에 토큰을 보내기. 이 때 idToken, accessToken 차이에 주의할 것
            
            SocialLoginAPI.googleLogin(request: SocialLoginRequest(token: idToken))
        }
    }
}
