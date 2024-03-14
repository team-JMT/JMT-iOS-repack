//
//  SocialLoginAPI.swift
//  App
//
//  Created by PKW on 2024/01/02.
//

import Foundation
import Alamofire


struct SocialLoginAPI {

    static func googleLogin(request: SocialLoginRequest, completion: @escaping (Result<SocialLoginModel,NetworkError>) -> ()) {
        AF.request(SocialLoginTarget.googleLogin(request))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: SocialLoginResponse.self) { response in
                switch response.result {
                case .success(let response):
                            
                    DefaultKeychainService.shared.tempAccessToken = response.data.accessToken
                    DefaultKeychainService.shared.tempRefreshToken = response.data.refreshToken
                    DefaultKeychainService.shared.tempAccessTokenExpiresIn = response.data.accessTokenExpiresIn
                    
                    completion(.success(response.toDomain))
                    
                case .failure(let error):
                    print("googleLogin 실패!!", error)
                }
            }
    }
    
    static func appleLogin(request: SocialLoginRequest, completion: @escaping (Result<SocialLoginModel,NetworkError>) -> ()) {
        
        AF.request(SocialLoginTarget.appleLogin(request))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: SocialLoginResponse.self) { response in
                switch response.result {
                case .success(let response):
                    
                    DefaultKeychainService.shared.tempAccessToken = response.data.accessToken
                    DefaultKeychainService.shared.tempRefreshToken = response.data.refreshToken
                    DefaultKeychainService.shared.tempAccessTokenExpiresIn = response.data.accessTokenExpiresIn
                    
                    completion(.success(response.toDomain))
                    
                case .failure(let error):
                    print("appleLogin 실패!!",error)
                }
            }
    }
    
    // 테스트 계정
    static func testLogin(completion: @escaping (Result<SocialLoginModel, NetworkError>) -> ()) {
        AF.request(SocialLoginTarget.testLogin)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: SocialLoginResponse.self) { response in
                switch response.result {
                case .success(let response):
                    
                    DefaultKeychainService.shared.accessToken = response.data.accessToken
                    DefaultKeychainService.shared.refreshToken = response.data.refreshToken
                    DefaultKeychainService.shared.accessTokenExpiresIn = response.data.accessTokenExpiresIn
                    
                    completion(.success(response.toDomain))
                case .failure(let error):
                    print("error")
                }
            }
    }
    
    static func logout(completion: @escaping (Result<LogoutResponse, NetworkError>) -> ()) {
        let accessToken = DefaultKeychainService.shared.accessToken ?? ""
        let refreshToken = DefaultKeychainService.shared.refreshToken ?? ""
        let request = LogoutRequest(accessToken: accessToken, refreshToken: refreshToken)
    
        AF.request(SocialLoginTarget.logout(request))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: LogoutResponse.self) { response in
                switch response.result {
                case .success(let response):
                    print(response)
                    completion(.success(response))
                    
                case .failure(let error):
                    print("logout Error")
                    completion(.failure(.custom("logout Error")))
                }
            }
    }
}
