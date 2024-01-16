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
    @IBOutlet weak var testImageView: UIImageView!
    
    
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
        if let data = profileImageView.image?.pngData() {
            
            let token = TokenUtils.getAccessToken()!
            let base64 = data.base64EncodedString()
            
            ProfileImageAPI.saveProfileImage(request: ProfileImageReqeust(token: token, imageStr: base64)) { response in
                
            }
        }
    }
    
    @IBAction func didTabProfileImageButton(_ sender: Any) {
        viewModel?.photoAuthService?.requestAuthorization(completion: { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                viewModel?.coordinator?.showImagePicker()
            case .failure:
                return
            }
        })
    }
    
    @IBAction func testButton(_ sender: Any) {
        ProfileImageAPI.getLoginInfo { response in
            switch response {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
