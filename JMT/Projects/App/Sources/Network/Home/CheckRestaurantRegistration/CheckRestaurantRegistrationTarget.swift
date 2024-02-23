//
//  CheckRestaurantRegistrationTarget.swift
//  JMTeng
//
//  Created by PKW on 2024/02/22.
//

import Foundation
import Alamofire

enum CheckRestaurantRegistrationTarget {
    case checkRestaurantRegistration(CheckRestaurantRegistrationRequest)
}

extension CheckRestaurantRegistrationTarget: TargetType {
    var method: Alamofire.HTTPMethod {
        switch self {
        case .checkRestaurantRegistration: return .get
        }
    }
    
    var path: String {
        switch self {
        case .checkRestaurantRegistration(let request): return "/restaurant/registration/\(request.kakaoSubId)"
        }
    }

    var parameters: RequestParams {
        switch self {
        case .checkRestaurantRegistration(let request): return .qurey(request)
        }
    }
}
