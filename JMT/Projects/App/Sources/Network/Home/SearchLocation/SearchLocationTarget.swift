//
//  SearchLocationTarget.swift
//  JMTeng
//
//  Created by PKW on 2024/01/22.
//

import Foundation
import Alamofire

enum SearchLocationTarget {
    case getSearchLocations(SearchLocationRequest)
}

extension SearchLocationTarget: TargetType {
    
    var method: HTTPMethod {
        switch self {
        case .getSearchLocations: return .get
        }
    }
    
    var path: String {
        switch self {
        case .getSearchLocations: return "/location/search"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getSearchLocations(let request): return .qurey(request)
        }
    }
}
