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
            .validate(statusCode: 200..<500)
            .responseDecodable(of: SocialLoginResponse.self) { response in
                switch response.result {
                case .success(let response):
                    
                    TokenUtils.saveTokens(accessToken: response.data.accessToken,
                                          refreshToken: response.data.refreshToken)
                    TokenUtils.saveAccessTokenExpiresIn(accessTokenExpiresIn: response.data.accessTokenExpiresIn)
                    
                    completion(.success(response.toDomain.userLoginAction))
                    
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    static func appleLogin(request: SocialLoginRequest, completion: @escaping (Result<String,NetworkError>) -> ()) {
        
        AF.request(SocialLoginTarget.appleLogin(request))
            .validate(statusCode: 200..<500)
            .responseDecodable(of: SocialLoginResponse.self) { response in
                switch response.result {
                case .success(let response):
                    
                    TokenUtils.saveTokens(accessToken: response.data.accessToken,
                                          refreshToken: response.data.refreshToken)
                    TokenUtils.saveAccessTokenExpiresIn(accessTokenExpiresIn: response.data.accessTokenExpiresIn)
                    
                    completion(.success(response.toDomain.userLoginAction))
                case .failure(let error):
                    print(error)
                }
            }
        
    }
}
