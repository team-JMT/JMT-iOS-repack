//
//  LocationTarget.swift
//  JMTeng
//
//  Created by PKW on 4/25/24.
//

import Foundation
import Alamofire

enum LocationTarget {
    case getSearchLocations(SearchLocationRequest)
    case getCurrentLocation(CurrentLocationRequest)
}

extension LocationTarget: TargetType {
    
    var method: HTTPMethod {
        switch self {
        case .getSearchLocations: return .get
        case .getCurrentLocation: return .post
        }
    }
    
    var path: String {
        switch self {
        case .getSearchLocations: return "/location/search"
        case .getCurrentLocation: return "/naver/location/convert"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getSearchLocations(let request): return .qurey(request)
        case .getCurrentLocation(let request): return .body(request)
        }
    }
}
