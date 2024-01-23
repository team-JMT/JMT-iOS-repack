//
//  UserInfoTarget.swift
//  JMTeng
//
//  Created by PKW on 2024/01/19.
//

import Foundation
import Alamofire

enum UserInfoTarget {
    case getUserInfo
}

extension UserInfoTarget: TargetType {
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getUserInfo: return .get
        }
    }
    
    var path: String {
        switch self {
        case .getUserInfo: return "/user/info"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getUserInfo: return .qurey(nil)
        }
    }
}
