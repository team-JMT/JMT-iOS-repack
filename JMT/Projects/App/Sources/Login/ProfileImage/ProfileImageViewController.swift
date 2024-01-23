//
//  ProfileImageViewController.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit

class ProfileImageViewController: UIViewController {
    
    var viewModel: ProfileImageViewModel?
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.onSuccess = { update in
            switch update {
            case .nicknameLabel:
                self.nicknameLabel.text = self.viewModel?.nickname ?? ""
            case .saveProfileImage:
                self.viewModel?.coordinator?.showTabBarViewController()
            }
        }
        
        setupUI()
        viewModel?.getUserInfo()
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
    
    func setupUI() {
        setCustomNavigationBarBackButton()
        profileImageView.layer.cornerRadius = 154 / 2
        doneButton.layer.cornerRadius = 8
    }
    
    @IBAction func didTabNextButton(_ sender: Any) {
        
        if let isDefault = viewModel?.isDefaultProfileImage {
            if isDefault {
                viewModel?.saveDefaultProfileImage()
            } else {
                viewModel?.saveProfileImage(imageData: profileImageView.image?.pngData())
            }
        }
    }
    
    @IBAction func didTabProfileImageButton(_ sender: Any) {
        viewModel?.photoAuthService?.requestAuthorization(completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                viewModel?.coordinator?.showProfilePopupViewController()
            case .failure:
                return
            }
        })
    }
}
