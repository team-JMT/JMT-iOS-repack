//
//  CurrentLocationTarget.swift
//  JMTeng
//
//  Created by PKW on 2024/02/12.
//

import Foundation
import Alamofire

enum CurrentLocationTarget {
    case getCurrentLocation(CurrentLocationRequest)
}

extension CurrentLocationTarget: TargetType {
    
    var method: HTTPMethod {
        switch self {
        case .getCurrentLocation: return .post
        }
    }
    
    var path: String {
        switch self {
//        case .getCurrentLocation: return "/location/current"
        case .getCurrentLocation: return "/naver/location/convert"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getCurrentLocation(let request): return .body(request)
        }
    }
}
