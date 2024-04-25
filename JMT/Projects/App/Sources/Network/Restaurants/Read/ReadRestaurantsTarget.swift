//
//  ReadRestaurantsTarget.swift
//  JMTeng
//
//  Created by PKW on 4/25/24.
//

import Foundation
import Alamofire

enum ReadRestaurantsTarget {
    case restaurantReviews(RestaurantReviewsRequest)
    case otherUserRestaurant(OtherUserRestaurantsRequest)
    case restaurantsList(RestaurantListRequest)
    case outBoundRestaurants(OutBoundRestaurantsRequest)
    case checkRegistrationRestaurant(CheckRegistrationRestaurantRequest)
    case detailRestaurant(DetailRestaurantRequest)
    case searchRestaurants(SearchRestaurantsRequest)
    case searchRestaurantsLocation(SearchRestaurantsLocationRequest)
}

extension ReadRestaurantsTarget: TargetType {
    var method: Alamofire.HTTPMethod {
        switch self{
        case .restaurantReviews: return .get
        case .otherUserRestaurant: return .post
        case .restaurantsList: return .post
        case .outBoundRestaurants: return .post
        case .checkRegistrationRestaurant: return .get
        case .detailRestaurant: return .post
            
        case .searchRestaurants: return .post
        case .searchRestaurantsLocation: return .get
        }
    }
    
    var path: String {
        switch self{
        case .restaurantReviews(let request): return "/restaurant/\(request.recommendRestaurantId)/review"
        case .otherUserRestaurant(let request): return "/restaurant/search/\(request.parameters.userId)"
        case .restaurantsList: return "/restaurant/search/map"
        case .outBoundRestaurants: return "/restaurant/search/outbound"
        case .checkRegistrationRestaurant(let request): return "/restaurant/registration/\(request.kakaoSubId)"
        case .detailRestaurant(let request): return "/restaurant/\(request.recommendRestaurantId)"
        case .searchRestaurants: return "/restaurant/search"
        case .searchRestaurantsLocation: return "/restaurant/location"
        }
    }
    
    var parameters: RequestParams {
        switch self{
        case .restaurantReviews(let request): return .qurey(request)
        case .otherUserRestaurant(let request): return .queryAndBody(request.parameters, request.body)
        case .restaurantsList(let request): return .queryAndBody(request.parameters, request.body)
        case .outBoundRestaurants(let request): return .body(request)
        case .checkRegistrationRestaurant(let request): return .qurey(request)
        case .detailRestaurant(let request): return .queryAndBody(request.recommendRestaurantId, request.coordinator)
        case .searchRestaurants(let request): return .body(request)
        case .searchRestaurantsLocation(let request): return .qurey(request)
        }
    }
}
