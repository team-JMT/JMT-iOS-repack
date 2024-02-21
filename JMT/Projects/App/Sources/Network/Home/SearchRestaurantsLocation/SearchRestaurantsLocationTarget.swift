//
//  SearchRestaurantsLocationTarget.swift
//  JMTeng
//
//  Created by PKW on 2024/02/20.
//

import Foundation
import Alamofire

enum SearchRestaurantsLocationTarget {
    case getRestaurantsLocationData(SearchRestaurantsLocationRequest)
}

extension SearchRestaurantsLocationTarget: TargetType {
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getRestaurantsLocationData: return .get
        }
    }
    
    var path: String {
        switch self {
        case .getRestaurantsLocationData: return "/restaurant/location"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getRestaurantsLocationData(let request): return .qurey(request)
        }
    }
}
