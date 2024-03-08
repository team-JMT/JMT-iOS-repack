//
//  GroupRestaurantsInfoTarget.swift
//  JMTeng
//
//  Created by PKW on 3/5/24.
//

import Foundation
import Alamofire

enum GroupRestaurantsInfoTarget {
//    case fetchGroupRestaurantsInfo(GroupRestaurantsInfoRequest)
    case fetchReviews(GroupRestaurantsInfoReviewRequest)
}

extension GroupRestaurantsInfoTarget: TargetType {
    var method: HTTPMethod {
        switch self {
//        case .fetchGroupRestaurantsInfo: return .get
        case .fetchReviews: return .get
        }
    }
    
    var path: String {
        switch self {
//        case .fetchGroupRestaurantsInfo: return "/restaurant"
        case .fetchReviews(let request): return "/restaurant/\(request.recommendRestaurantId)/review"
        }
    }
    
    var parameters: RequestParams {
        switch self {
//        case .fetchGroupRestaurantsInfo(let request): return .qurey(request)
        case .fetchReviews(let request): return .qurey(request)
        }
    }
}
 
