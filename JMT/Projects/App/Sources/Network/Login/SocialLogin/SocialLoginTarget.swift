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
    case testLogin
    case logout(LogoutRequest)
}

extension SocialLoginTarget: TargetType {
    var method: HTTPMethod {
        switch self {
        case .appleLogin: return .post
        case .googleLogin: return .post
        case .testLogin: return .post
        case .logout: return .delete
        }
    }
    
    var path: String {
        switch self {
        case .appleLogin: return "/auth/apple"
        case .googleLogin: return "/auth/google"
        case .testLogin: return "/auth/test"
        case .logout: return "/auth/user"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .appleLogin(let request): return .body(request)
        case .googleLogin(let request): return .body(request)
        case .testLogin: return .qurey(nil)
        case .logout(let request): return .body(request)
        }
    }
}
