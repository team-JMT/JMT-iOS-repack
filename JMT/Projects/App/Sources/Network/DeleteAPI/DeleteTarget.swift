//
//  DeleteTarget.swift
//  JMTeng
//
//  Created by PKW on 3/27/24.
//

import Foundation
import Alamofire

enum DeleteTarget {
    case deleteRestauran(DeleteRestaurantRequest)
}

extension DeleteTarget: TargetType {
    var method: Alamofire.HTTPMethod {
        switch self {
        case .deleteRestauran: return .delete
        }
    }
    
    var path: String {
        switch self {
        case .deleteRestauran(let request): return "restaurant/\(request.id)"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .deleteRestauran(let request): return .qurey(request)
        }
    }
}
