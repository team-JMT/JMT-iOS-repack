//
//  SocialLocinViewController.swift
//  App
//
//  Created by PKW on 2023/12/19.
//

import UIKit
import AuthenticationServices

class SocialLoginViewController: UIViewController {
    
    deinit {
        print("SocialLoginViewController Deinit")
    }
    
    @IBOutlet weak var appleLoginView: UIView!
    @IBOutlet weak var googleLoginView: UIView!
    
    var viewModel: SocialLoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        appleLoginView.layer.cornerRadius = 10
        googleLoginView.layer.cornerRadius = 10
        
        googleLoginView.layer.borderColor = UIColor.gray100?.cgColor
        googleLoginView.layer.borderWidth = 1.5
    }
    
    @IBAction func didTabGoogleLoginButton(_ sender: Any) {
        guard viewModel?.isEnabled == true else { return }
        
        viewModel?.startGoogleLogin()
    }
    
    @IBAction func didTabAppleLoginButton(_ sender: Any) {
        guard viewModel?.isEnabled == true else { return }
        
        viewModel?.startAppleLogin()
    }
}

