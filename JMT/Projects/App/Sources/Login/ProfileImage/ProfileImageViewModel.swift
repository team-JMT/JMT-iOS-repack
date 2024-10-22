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
    
    weak var coordinator: ProfileImageCoordinator?
    var photoAuthService: PhotoAuthService?
    
    var onSuccess: ((UpdateUI) -> ())?
    var onFailure: (() -> ())?
    
    var nickname: String?
    var isDefaultProfileImage: Bool = true
    var preventButtonTouch: Bool = false
    
    func getUserInfo() {
        UserInfoAPI.getLoginInfo { response in
            switch response {
            case .success(let info):
                self.nickname = info.nickname
                self.onSuccess?(.nicknameLabel)
            case .failure(let error):
                print("getUserInfo 실패!!", error)
                self.onFailure?()
            }
        }
    }
    
    func saveProfileImage(imageData: Data?) {
        
        preventButtonTouch = true
        
        if let data = imageData {
            let base64 = data.base64EncodedString()
            ProfileImageAPI.saveProfileImage(request: ProfileImageReqeust(imageStr: base64)) { response in
                switch response {
                case .success(let response):
                
                    switch response.code {
                    case "UNAUTHORIZED":
                        print("인증이 필요하므로 엑세스토큰 갱신 필요")
                    default:
            
                        DefaultKeychainService.shared.accessToken = DefaultKeychainService.shared.tempAccessToken
                        DefaultKeychainService.shared.refreshToken = DefaultKeychainService.shared.tempRefreshToken
                        DefaultKeychainService.shared.accessTokenExpiresIn = DefaultKeychainService.shared.tempAccessTokenExpiresIn
                        
                        DefaultKeychainService.shared.tempAccessToken = nil
                        DefaultKeychainService.shared.tempRefreshToken = nil
                        DefaultKeychainService.shared.tempAccessTokenExpiresIn = nil
                        
                        self.onSuccess?(.saveProfileImage)
                    }
                case .failure(let error):
                    print("saveProfileImage - ProfileImageAPI.saveProfileImage 실패!!", error)
                    self.onFailure?()
                }
                
                self.preventButtonTouch = false
            }
        }
    }
    
    func saveDefaultProfileImage() {
        
        preventButtonTouch = true
        
        ProfileImageAPI.saveDefaultProfileImage { response in
            switch response {
            case .success(let response):
                
                switch response.code {
                case "UNAUTHORIZED":
                    print("인증이 필요하므로 엑세스토큰 갱신 필요")
                default:
                    
                    DefaultKeychainService.shared.accessToken = DefaultKeychainService.shared.tempAccessToken
                    DefaultKeychainService.shared.refreshToken = DefaultKeychainService.shared.tempRefreshToken
                    DefaultKeychainService.shared.accessTokenExpiresIn = DefaultKeychainService.shared.tempAccessTokenExpiresIn
                    
                    DefaultKeychainService.shared.tempAccessToken = nil
                    DefaultKeychainService.shared.tempRefreshToken = nil
                    DefaultKeychainService.shared.tempAccessTokenExpiresIn = nil
                    
                    self.onSuccess?(.saveProfileImage)
                }
            case .failure(let error):
                print("saveDefaultProfileImage - 실패!!",error)
            }
            
            self.preventButtonTouch = false
        }
    }
}
