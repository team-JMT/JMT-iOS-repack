//
//  ProfileImageViewController.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit

class ProfileImageViewController: UIViewController {

    var viewModel: ProfileImageViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func didTabNextButton(_ sender: Any) {
        viewModel?.coordinator?.showTabBarViewController()
    }
}
