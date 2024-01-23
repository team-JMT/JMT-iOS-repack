//
//  RefreshTokenTarget.swift
//  JMTeng
//
//  Created by PKW on 2024/01/19.
//

import Foundation
import Alamofire

enum RefreshTokenTarget {
    case refreshToken(RefreshTokenRequest)
}

extension RefreshTokenTarget: TargetType {
    var method: Alamofire.HTTPMethod {
        switch self {
        case .refreshToken: return .post
        }
    }
    
    var path: String {
        switch self {
        case .refreshToken: return "/token"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .refreshToken(let request): return .body(request)
        }
    }
}
 
