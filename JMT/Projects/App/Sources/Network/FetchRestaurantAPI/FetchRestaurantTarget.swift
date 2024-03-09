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
    case fetchSearchRestaurants(SearchRestaurantsRequest)
    case checkRegistrationRestaurant(CheckRegistrationRestaurantRequest)
}

extension FetchRestaurantTarget: TargetType {
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetchDetailRestaurant: return .post
        case .fetchSearchMapRestaurants: return .post
        case .fetchSearchRestaurants: return .get
        case .checkRegistrationRestaurant: return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchDetailRestaurant(let request): return "/restaurant/\(request.recommendRestaurantId)"
        case .fetchSearchMapRestaurants: return "/restaurant/search/map"
        case .fetchSearchRestaurants: return "/restaurant/location"
        case .checkRegistrationRestaurant(let request): return "/restaurant/registration/\(request.kakaoSubId)"
       
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .fetchDetailRestaurant(let request): return .queryAndBody(request.recommendRestaurantId, request.coordinator)
        case .fetchSearchMapRestaurants(let request): return .queryAndBody(request.parameters, request.body)
        case .fetchSearchRestaurants(let request): return .qurey(request)
        case .checkRegistrationRestaurant(let request): return .qurey(request)
        }
    }
}
