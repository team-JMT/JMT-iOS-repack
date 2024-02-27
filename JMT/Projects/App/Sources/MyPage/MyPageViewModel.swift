//
//  MyPageViewModel.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import Foundation
import Alamofire


class MyPageViewModel {
    
    weak var coordinator: MyPageCoordinator?
    private let keychainAccess: KeychainAccessible
    
    
    var userInfo: MyPageUserLogin? {
        didSet {
            self.onUserInfoLoaded?()
        }
    }
    var onUserInfoLoaded: (() -> Void)?
        
    
    
    init(keychainAccess: KeychainAccessible = DefaultKeychainAccessible()) {
        self.keychainAccess = keychainAccess
    }
    
    // ID 토큰과 액세스 토큰 값을 확인하는 함수
    func fetchTokens() {
        // ID 토큰 저장 여부 플래그 확인
        if let isIdTokenSaved = keychainAccess.getToken("isIdTokenSaved"), isIdTokenSaved == "true", let idToken = keychainAccess.getToken("idToken") {
            print("---===---")
            print("ID Token: \(idToken)")
        } else {
            print("ID Token is not available. Checking if saved correctly...")
        }

        // 액세스 토큰 조회
        if let accessToken = keychainAccess.getToken("accessToken") {
            print("Access Token: \(accessToken)")
        } else {
            print("Access Token is not available")
        }
    }
    
    func fetchUserInfo() {
        guard let accessToken = keychainAccess.getToken("accessToken") else {
            print("Access Token is not available")
            return
        }

        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer \(accessToken)"
        ]

        AF.request("https://api.jmt-matzip.dev/api/v1/user/info", method: .get, headers: headers).responseDecodable(of: MyPageUserLogin.self) { response in
            switch response.result {
            case .success(let userInfo):
                self.userInfo = userInfo
            case .failure(let error):
                print(error)
            }
        }
    }

    func getUserInfo() {
        UserInfoAPI.getLoginInfo { response in
            switch response {
            case .success(let info):
               print(1)
            case .failure(let error):
                print("getUserInfo 실패!!", error)
              //self.onFailure?()
            }
        }
    }
    
    func getMyPagUserLoginInfo() {
        MyPageUserInfo.getUserInfo { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userInfo):
                    // 사용자 정보 처리 로직 (예: 데이터 바인딩)
                    print(userInfo)
                    self?.onDataUpdated?()
                case .failure(let error):
                    print("getUserInfo 실패: \(error)")
                }
            }
        }
    }
        
    func handleLoginSuccess(idToken: String) {
        keychainAccess.saveToken("idToken", idToken)
        keychainAccess.saveToken("isIdTokenSaved", "true") // 플래그 저장
        print("ID Token saved: \(idToken)")
    }
    
    // 로그아웃 처리
    func logout() {
        keychainAccess.removeAll()
        print("Logged out and all tokens removed.")
    }

    
    // 데이터를 저장할 프로퍼티
    //    var restaurantData: [Restaurant] = [] {
    //        didSet {
    //            self.onDataUpdated?()
    //        }
    //    }
    
    // 데이터가 업데이트될 때 호출될 클로저
    var onDataUpdated: (() -> Void)?
    
    
    
   
}


