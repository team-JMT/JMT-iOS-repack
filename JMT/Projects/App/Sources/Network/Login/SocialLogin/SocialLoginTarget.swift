//
//  SocialLoginTarget.swift
//  App
//
//  Created by PKW on 2024/01/02.
//

import Foundation
import Alamofire

enum SocialLoginTarget {
    case appleLogin(SocialLoginRequest)
    case googleLogin(SocialLoginRequest)
}

extension SocialLoginTarget: TargetType {
    var baseURL: String {
        return NetworkConfiguration.baseUrl
    }
    
    var method: HTTPMethod {
        switch self {
        case .appleLogin: return .post
        case .googleLogin: return .post
        }
    }
    
    var path: String {
        switch self {
        case .appleLogin: return "/auth/apple"
        case .googleLogin: return "/auth/google"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .appleLogin(let request): return .body(request)
        case .googleLogin(let request): return .body(request)
        }
    }
}
