//
//  SocialLoginAPI.swift
//  App
//
//  Created by PKW on 2024/01/02.
//

import Foundation
import Alamofire


struct SocialLoginAPI {
    
    static func googleLogin(request: SocialLoginRequest, completion: @escaping (Result<String,NetworkError>) -> ()) {
        AF.request(SocialLoginTarget.googleLogin(request))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: SocialLoginResponse.self) { response in
                switch response.result {
                case .success(let response):
                    
                    DefaultKeychainService.shared.accessToken = response.data.accessToken
                    DefaultKeychainService.shared.refreshToken = response.data.refreshToken
                    DefaultKeychainService.shared.accessTokenExpiresIn = response.data.accessTokenExpiresIn
                    
                    completion(.success(response.toDomain.userLoginAction))
                    
                case .failure(let error):
                    print("googleLogin 실패!!", error)
                }
            }
    }
    
    static func appleLogin(request: SocialLoginRequest, completion: @escaping (Result<String,NetworkError>) -> ()) {
        
        AF.request(SocialLoginTarget.appleLogin(request))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: SocialLoginResponse.self) { response in
                switch response.result {
                case .success(let response):
                    
                    DefaultKeychainService.shared.accessToken = response.data.accessToken
                    DefaultKeychainService.shared.refreshToken = response.data.refreshToken
                    DefaultKeychainService.shared.accessTokenExpiresIn = response.data.accessTokenExpiresIn
                    
                    completion(.success(response.toDomain.userLoginAction))
                    
                case .failure(let error):
                    print("appleLogin 실패!!",error)
                }
            }
    }
    
    // 테스트 계정
    static func testLogin(completion: @escaping (Result<String, NetworkError>) -> () ) {
        AF.request(SocialLoginTarget.testLogin)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: SocialLoginResponse.self) { response in
                switch response.result {
                case .success(let response):
                    
                    DefaultKeychainService.shared.accessToken = response.data.accessToken
                    DefaultKeychainService.shared.refreshToken = response.data.refreshToken
                    DefaultKeychainService.shared.accessTokenExpiresIn = response.data.accessTokenExpiresIn
                    
                    completion(.success(response.toDomain.userLoginAction))
                case .failure(let error):
                    print("error")
                }
            }
    }
}
