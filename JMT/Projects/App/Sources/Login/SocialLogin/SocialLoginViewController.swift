//
//  SocialLocinViewController.swift
//  App
//
//  Created by PKW on 2023/12/19.
//

import UIKit

class SocialLoginViewController: UIViewController {

    var viewModel: SocialLoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func didTabNextButton(_ sender: Any) {
        print("----", viewModel)
        viewModel?.coordinator?.showNicknameViewController()
    }
}
