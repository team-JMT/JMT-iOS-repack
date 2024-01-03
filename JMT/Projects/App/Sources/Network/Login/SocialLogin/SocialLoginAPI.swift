//
//  SocialLoginAPI.swift
//  App
//
//  Created by PKW on 2024/01/02.
//

import Foundation
import Alamofire

struct SocialLoginAPI {
    static func googleLogin(request: SocialLoginRequest) {
        AF.request(SocialLoginTarget.googleLogin(request)).responseDecodable { (response: AFDataResponse<SocialLoginResponse>) in
            switch response.result {
            case .success(let response):
                print(response.toDomain)
            case .failure(let error):
                print(error)
            }
        }
    }
}
