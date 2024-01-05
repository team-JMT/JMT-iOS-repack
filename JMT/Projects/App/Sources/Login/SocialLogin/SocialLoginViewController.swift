//
//  SocialLocinViewController.swift
//  App
//
//  Created by PKW on 2023/12/19.
//

import UIKit
import AuthenticationServices

class SocialLoginViewController: UIViewController {
    
    var viewModel: SocialLoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
  
    
    @IBAction func didTabGoogleLoginButton(_ sender: Any) {
        viewModel?.startGoogleLogin()
    }
    
    @IBAction func didTabAppleLoginButton(_ sender: Any) {
        viewModel?.startAppleLogin()
    }
}

