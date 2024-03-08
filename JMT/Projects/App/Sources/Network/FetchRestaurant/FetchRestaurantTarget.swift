//
//  FetchRestaurantTarget.swift
//  JMTeng
//
//  Created by PKW on 3/5/24.
//

import Foundation
import Alamofire

enum FetchRestaurantTarget {
    case fetchDetailRestaurant(DetailRestaurantRequest)
    case fetchSearchMapRestaurants(SearchMapRestaurantRequest)
}

extension FetchRestaurantTarget: TargetType {
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetchDetailRestaurant: return .post
        case .fetchSearchMapRestaurants: return .post
        }
    }
    
    var path: String {
        switch self {
        case .fetchDetailRestaurant(let request): return "restaurant/\(request.recommendRestaurantId)"
        case .fetchSearchMapRestaurants: return "/restaurant/search/map"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .fetchDetailRestaurant(let request): return .queryAndBody(request.recommendRestaurantId, request.coordinator)
        case .fetchSearchMapRestaurants(let request): return .queryAndBody(request.parameters, request.body)
        }
    }
}
