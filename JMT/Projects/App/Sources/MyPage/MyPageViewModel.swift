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
    
    
    var userId: Int?
    var numberOfRestaurants: Int?

    
    
    var userInfo: MyPageUserLogin? {
        didSet {
            self.onUserInfoLoaded?()
        }
    }
    
    var totalRestaurants: Int? {
            didSet {
                onTotalRestaurantsUpdated?()
            }
        }
    
    var restaurantsData: [Restaurant] = [] {
           didSet {
               self.onRestaurantsDataUpdated?()
           }
       }
    var onRestaurantsDataUpdated: (() -> Void)?
    var onUserInfoLoaded: (() -> Void)?
    var onTotalRestaurantsUpdated: (() -> Void)?
    var onDataUpdated: (() -> Void)?
    
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
        keychainAccess.saveToken("isIdTokenSaved", "true")
        print("ID Token saved: \(idToken)")
    }
    
    
    func fetchRestaurants(userId: Int) {

        guard let userId = self.userId else {
            print("User ID is not available")
            return
        }

        guard let accessToken = keychainAccess.getToken("accessToken") else {
            print("Access Token is not available")
            return
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]

        let url = "https://api.jmt-matzip.dev/api/v1/restaurant/search/\(userId)?page=0&size=20"

        AF.request(url, method: .post, headers: headers).responseDecodable(of: ResturantResponse.self) { response in
            switch response.result {
                case .success(let responseData):
                    self.numberOfRestaurants = responseData.data?.page?.numberOfElements
                    self.onTotalRestaurantsUpdated?()
                    self.restaurantsData = responseData.data?.restaurants ?? []
                    DispatchQueue.main.async {
                        self.onRestaurantsDataUpdated?()
                    }
                case .failure(let error):
                    print("Error fetching restaurants data: \(error)")
            }
        }
    }

    
    
}

        
