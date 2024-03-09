//
//  RegistrationRestaurantTarget.swift
//  JMTeng
//
//  Created by PKW on 3/9/24.
//

import Foundation
import Alamofire

enum RegistrationRestaurantTarget {
    case registrationRestaurantLocation(RegistrationRestaurantLocationRequest)
}

extension RegistrationRestaurantTarget: TargetType {
    var method: Alamofire.HTTPMethod {
        switch self {
        case .registrationRestaurantLocation: return .post
        }
    }
    
    var path: String {
        switch self {
        case .registrationRestaurantLocation: return "restaurant/location"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .registrationRestaurantLocation(let request): return .body(request)
        }
    }
}
