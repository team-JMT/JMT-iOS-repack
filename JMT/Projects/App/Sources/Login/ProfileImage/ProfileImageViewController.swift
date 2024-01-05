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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 부모 코디네이터에 따라서 네비게이션바 Hidden
        if viewModel?.coordinator?.parentCoordinator is DefaultSocialLoginCoordinator {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    @IBAction func didTabNextButton(_ sender: Any) {
        viewModel?.coordinator?.showTabBarViewController()
    }
}
