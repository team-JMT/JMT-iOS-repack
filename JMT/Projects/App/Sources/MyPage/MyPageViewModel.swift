//
//  MyPageViewModel.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import Foundation


class MyPageViewModel {
    
    weak var coordinator: MyPageCoordinator?
    private let keychainAccess: KeychainAccessible
    
    let test = "홈"
    
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
    
    // 세그먼트 인덱스에 따라 다른 API 호출
    func fetchData(forSegmentIndex index: Int) {
        switch index {
        case 0:
            fetchRestaurantsFromAPI1()
        case 1:
            fetchRestaurantsFromAPI2()
        case 2:
            fetchRestaurantsFromAPI3()
        default:
            break
        }
    }
    
    private func fetchRestaurantsFromAPI1() {
        // API1을 호출하고 결과를 restaurantData에 저장하는 로직
        
    }
    
    private func fetchRestaurantsFromAPI2() {
        // API2를 호출하고 결과를 restaurantData에 저장하는 로직
    }
    
    private func fetchRestaurantsFromAPI3() {
        // API3을 호출하고 결과를 restaurantData에 저장하는 로직
    }
    
    //MARK: - 로그인 상태를 체크하는 함수
    
    func checkLoginStatus() {
        //   if isLoggedIn {
        // 로그인 되어 있는 상태
        print("User is logged in")
        //           } else {
        //               // 로그인 되어 있지 않은 상태
        //               print("User is not logged in")
        //           }
    }
   
}


