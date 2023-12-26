//
//  NicknameViewController.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit

class NicknameViewController: UIViewController {

    var viewModel: NicknameViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func didTabNextButton(_ sender: Any) {
        viewModel?.coordinator?.showProfileViewController()
    }
}
