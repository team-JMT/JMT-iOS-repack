//
//  UserLocationTarget.swift
//  JMTeng
//
//  Created by PKW on 2024/01/20.
//

import Foundation
import Alamofire

enum UserLocationTarget {
    case getSearchLocalDatas(UserLocationRequest)
}

extension UserLocationTarget: TargetType {
    
    
   
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getSearchLocalDatas: return .get
        }
    }
    
    var path: String {
        switch self {
        case .getSearchLocalDatas: return "/naver/location/convert"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getSearchLocalDatas(let request): return .body(request)
        }
    }
}
