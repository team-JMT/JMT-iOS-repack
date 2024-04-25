//
//  CreateRestaurantsTarget.swift
//  JMTeng
//
//  Created by PKW on 4/25/24.
//

import Foundation
import Alamofire

enum CreateRestaurantsTarget {
    case createRestaurantLocation(CreateRestaurantLocationRequest)
    case createRestaurant(CreateRestaurantRequest)
    case createReview(CreateRestaurantReviewRequest)
}

extension CreateRestaurantsTarget: TargetType {
    var method: Alamofire.HTTPMethod {
        switch self{
        case .createRestaurantLocation: return .post
        case .createRestaurant: return .post
        case .createReview: return .post
        }
    }
    
    var path: String {
        switch self{
        case .createRestaurantLocation: return "/restaurant/location"
        case .createRestaurant: return "/restaurant"
        case .createReview(let request): return "/restaurant/\(request.recommendRestaurantId)/review"
        }
    }
    
    var parameters: RequestParams {
        switch self{
        case .createRestaurantLocation(let request): return .body(request)
        case .createRestaurant(let request): return .body(nil)
        case .createReview(let request): return .qurey(request)
        }
    }
}
