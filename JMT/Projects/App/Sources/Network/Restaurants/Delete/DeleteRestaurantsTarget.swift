//
//  DeleteRestaurantsTarget.swift
//  JMTeng
//
//  Created by PKW on 4/25/24.
//

import Foundation
import Alamofire

enum DeleteRestaurantsTarget {
    case deleteRestaurant(DeleteRestaurantRequest)
}

extension DeleteRestaurantsTarget: TargetType {
    var method: Alamofire.HTTPMethod {
        switch self{
        case .deleteRestaurant: return .delete
        }
    }
    
    var path: String {
        switch self{
        case .deleteRestaurant(let request): return "restaurant/\(request.id)"
        }
    }
    
    var parameters: RequestParams {
        switch self{
        case .deleteRestaurant(let request): return .qurey(request)
        }
    }
}
