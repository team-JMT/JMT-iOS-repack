//
//  UpdateRestaurantsTarget.swift
//  JMTeng
//
//  Created by PKW on 4/25/24.
//

import Foundation
import Alamofire

enum UpdateRestaurantsTarget {
    case editRestaurant(EditRestaurantRequest)
}

extension UpdateRestaurantsTarget: TargetType {
    var method: Alamofire.HTTPMethod {
        switch self{
        case .editRestaurant: return .put
        }
    }
    
    var path: String {
        switch self{
        case .editRestaurant: return "/restaurant"
        }
    }
    
    var parameters: RequestParams {
        switch self{
        case .editRestaurant(let request): return .body(request)
        }
    }
}
