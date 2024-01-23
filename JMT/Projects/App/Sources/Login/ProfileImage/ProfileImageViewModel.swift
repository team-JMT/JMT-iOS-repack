//
//  ProfileImageViewModel.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import Foundation

class ProfileImageViewModel {
    enum UpdateUI {
        case nicknameLabel
        case saveProfileImage
    }
    
    weak var coordinator: DefaultProfileImageCoordinator?
    var photoAuthService: DefaultPhotoAuthService?
    
    var onSuccess: ((UpdateUI) -> ())?
    var onFailure: (() -> ())?
    
    var nickname: String?
    var isDefaultProfileImage: Bool = false
    
    func getUserInfo() {
        ProfileImageAPI.getLoginInfo { response in
            switch response {
            case .success(let info):
                
                print(info)
                self.nickname = info.nickname
                self.onSuccess?(.nicknameLabel)
            case .failure(let error):
                print(error)
                self.onFailure?()
            }
        }
    }
    
    func saveProfileImage(imageData: Data?) {
        if let data = imageData {
            
            let base64 = data.base64EncodedString()
            
            ProfileImageAPI.saveProfileImage(request: ProfileImageReqeust(imageStr: base64)) { response in
                switch response {
                case .success:
                    self.onSuccess?(.saveProfileImage)
                case .failure:
                    self.onFailure?()
                }
            }
        }
    }
    
    func saveDefaultProfileImage() {
        ProfileImageAPI.saveDefaultProfileImage { response in
            switch response {
            case .success(let response):
                print(response)
                self.onSuccess?(.saveProfileImage)
            case .failure(let error):
                print(error)
            }
        }
    }
}
