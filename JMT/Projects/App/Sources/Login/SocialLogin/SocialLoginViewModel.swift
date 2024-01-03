//
//  SocialLoginViewModel.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import Foundation

class SocialLoginViewModel {
    weak var coordinator: DefaultSocialLoginCoordinator?
    
    func startGoogleLogin() {
        coordinator?.showGoogleLoginViewController(completion: { result in
            switch result {
            case .success(let idToken):
                SocialLoginAPI.googleLogin(request: SocialLoginRequest(token: idToken)) { result in
                    switch result {
                    case .success(let action):
                        switch action {
                        case "NICKNAME_PROCESS":
                            print("닉네임 설정")
                            self.coordinator?.showNicknameViewController()
                        default:
                            print("예외")
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                // 에러처리 어떻게 할지 정해야함
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
                    case .success(let action):
                        switch action {
                        case "NICKNAME_PROCESS":
                            print("닉네임 설정")
                            self?.coordinator?.showNicknameViewController()
                        default:
                            print("예외")
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
