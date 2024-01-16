//
//  SocialLoginViewModel.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import Foundation

enum UserLoginAction: String {
    case SIGN_UP = "SIGN_UP"
    case NICKNAME_PROCESS = "NICKNAME_PROCESS"
    case PROFILE_IMAGE_PROCESS = "PROFILE_IMAGE_PROCESS"
    case LOG_IN = "LOG_IN"
}

class SocialLoginViewModel {
    weak var coordinator: DefaultSocialLoginCoordinator?
    
    func startGoogleLogin() {
        coordinator?.showGoogleLoginViewController(completion: { result in
            switch result {
            case .success(let idToken):
                
                SocialLoginAPI.googleLogin(request: SocialLoginRequest(token: idToken)) { result in
                    switch result {
                    case .success(let actionStr):
                        if let action = UserLoginAction(rawValue: actionStr) {
                            switch action {
                            case .SIGN_UP, .NICKNAME_PROCESS:
                                self.coordinator?.showNicknameViewController()
                            case .PROFILE_IMAGE_PROCESS:
                                self.coordinator?.showProfileViewController()
                            case .LOG_IN:
                                
                                self.coordinator?.showProfileViewController()
                                
//                                let appCoordinator = self.coordinator?.getTopCoordinator()
//                                appCoordinator?.showTabBarViewController()
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func startAppleLogin() {
        // 클로저 등록
        coordinator?.onAppleLoginSuccess = { [weak self] result in
            switch result {
            case .success(let idToken):
                
                SocialLoginAPI.appleLogin(request: SocialLoginRequest(token: idToken)) { result in
                    switch result {
                    case .success(let actionStr):
                        
                        if let action = UserLoginAction(rawValue: actionStr) {
                            switch action {
                            case .SIGN_UP, .NICKNAME_PROCESS:
                                self?.coordinator?.showNicknameViewController()
                            case .PROFILE_IMAGE_PROCESS:
                                self?.coordinator?.showProfileViewController()
                            case .LOG_IN:
                                let appCoordinator = self?.coordinator?.getTopCoordinator()
                                appCoordinator?.showTabBarViewController()
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                // 에러 처리
                print(error)
            }
        }
        coordinator?.showAppleLoginViewController()
    }
}

    
