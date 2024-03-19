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
        print("Fetching user info...")
        guard let accessToken = keychainAccess.getToken("accessToken") else {
            print("Access Token is not available")
            return
        }
        
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request("https://api.jmt-matzip.dev/api/v1/user/info", method: .get, headers: headers).responseDecodable(of: MyPageUserLogin.self) { [weak self] response in
            switch response.result {
            case .success(let userInfo):
                self?.userInfo = userInfo
                print("Successfully fetched user info: \(userInfo)")
                // 사용자 정보 가져오기에 성공한 후 식당 정보를 가져옵니다.
                if let userId = userInfo.data?.id {
                    self?.userId = userId
                    self?.fetchRestaurants()
                }
            case .failure(let error):
                print("Error fetching user info: \(error)")
            }
        }
    }

    func fetchRestaurants() {
        print("Fetching restaurants for user ID: \(String(describing: userId))")

        guard let accessToken = keychainAccess.getToken("accessToken") else {
            print("Access Token is not available")
            return
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]

        let url = "https://api.jmt-matzip.dev/api/v1/restaurant/search?page=0&size=20"
        
        // 사용자 위치와 필터 옵션을 포함하는 요청 본문
        let parameters: [String: Any] = [
            "userLocation": [
                "x": "127.0596",
                "y": "37.6633"
            ],
            "filter": [
                "categoryFilter": "string",
                "isCanDrinkLiquor": true
            ]
        ]

        // Alamofire로 POST 요청 보내기
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: ResturantResponse.self) { response in
            switch response.result {
            case .success(let responseData):
                print("Successfully fetched restaurants data: \(responseData)")
                self.restaurantsData = responseData.data?.restaurants ?? []
                self.totalRestaurants = responseData.data?.page?.totalElements // 올바른 접근 방식

                self.onRestaurantsDataUpdated?() // 데이터 업데이트 이벤트 호출
                
            case .failure(let error):
                print("Error fetching restaurants data: \(error)")
            }
        }
    }

    
    func fetchUserId() {
        
        print("Fetching user ID...")
              // 여기서 사용자 ID를 가져오는 로직 구현 후 성공 시
          
            guard let accessToken = keychainAccess.getToken("accessToken") else {
                print("Access Token is not available")
                return
            }
            
            let headers: HTTPHeaders = [
                "accept": "*/*",
                "Authorization": "Bearer \(accessToken)"
            ]
            
            AF.request("https://api.jmt-matzip.dev/api/v1/user/info", method: .get, headers: headers).responseDecodable(of: MyPageUserLogin.self) { [weak self] response in
                switch response.result {
                case .success(let userInfo):
                    self?.userId = userInfo.data?.id
                    self?.fetchRestaurants()
                    print("Successfully fetched user ID: \(self?.userId ?? 0)")

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
    
    
    
    
}

        
