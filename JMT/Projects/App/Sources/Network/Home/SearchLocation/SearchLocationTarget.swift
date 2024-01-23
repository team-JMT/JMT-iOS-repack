//
//  SearchLocationTarget.swift
//  JMTeng
//
//  Created by PKW on 2024/01/22.
//

import Foundation
import Alamofire

enum SearchLocationTarget {
    case getLocations(SearchLocationRequest)
}

extension SearchLocationTarget: TargetType {
    
    var baseURL: String {
        return "https://openapi.naver.com/v1/search/local.json"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getLocations: return .get
        }
    }
    
    var path: String {
        switch self {
        case .getLocations: return ""
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getLocations(let request): return .body(request)
        }
    }
}
