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
    case fetchSearchRestaurantsLocation(SearchRestaurantsLocationRequest)
    case checkRegistrationRestaurant(CheckRegistrationRestaurantRequest)
    case fetchRestaurantReviews(RestaurantReviewRequest)
    
    case fetchSearchRestaurants(SearchRestaurantsRequest)
    case fetchRestaurantsOutBound(SearchRestaurantsOutBoundRequest)
}

extension FetchRestaurantTarget: TargetType {
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetchDetailRestaurant: return .post
        case .fetchSearchMapRestaurants: return .post
        case .fetchSearchRestaurantsLocation: return .get
        case .checkRegistrationRestaurant: return .get
        case .fetchRestaurantReviews: return .get
            
        case .fetchSearchRestaurants: return .post
        case .fetchRestaurantsOutBound: return .post
        }
    }
    
    var path: String {
        switch self {
        case .fetchDetailRestaurant(let request): return "/restaurant/\(request.recommendRestaurantId)"
        case .fetchSearchMapRestaurants: return "/restaurant/search/map"
        case .fetchSearchRestaurantsLocation: return "/restaurant/location"
        case .checkRegistrationRestaurant(let request): return "/restaurant/registration/\(request.kakaoSubId)"
        case .fetchRestaurantReviews(let request): return "/restaurant/\(request.recommendRestaurantId)/review"
            
        case .fetchSearchRestaurants: return "/restaurant/search"
        case .fetchRestaurantsOutBound: return "/restaurant/search/outbound"
       
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .fetchDetailRestaurant(let request): return .queryAndBody(request.recommendRestaurantId, request.coordinator)
        case .fetchSearchMapRestaurants(let request): return .queryAndBody(request.parameters, request.body)
        case .fetchSearchRestaurantsLocation(let request): return .qurey(request)
        case .checkRegistrationRestaurant(let request): return .qurey(request)
        case .fetchRestaurantReviews(let request): return .qurey(request)
            
        case .fetchSearchRestaurants(let request): return .body(request)
        case .fetchRestaurantsOutBound(let request): return .qurey(request)
        }
    }
}
