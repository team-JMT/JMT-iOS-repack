//
//  ReadGroupTarget.swift
//  JMTeng
//
//  Created by PKW on 4/25/24.
//

import Foundation
import Alamofire

enum ReadGroupTarget {
    case fetchMyGroup
    case fetchGroups(SearchGroupRequest)
}

extension ReadGroupTarget: TargetType {
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetchMyGroup: return .get
        case .fetchGroups: return .post
        }
    }
    
    var path: String {
        switch self {
        case .fetchMyGroup: return "/group/my"
        case .fetchGroups: return "/group/search"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .fetchMyGroup: return .qurey(nil)
        case .fetchGroups(let request): return .body(request)
        }
    }
}
