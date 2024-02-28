//
//  GroupTarget.swift
//  JMTeng
//
//  Created by PKW on 2024/02/28.
//

import Foundation
import Alamofire

enum GroupTarget {
    case fetchMyGroup
    case leaveGroup(GroupRequest)
}

extension GroupTarget: TargetType {
    var method: HTTPMethod {
        switch self {
        case .fetchMyGroup: return .get
        case .leaveGroup: return .delete
        }
    }
    
    var path: String {
        switch self {
        case .fetchMyGroup: return "/group/my"
        case .leaveGroup(let request): return "/group/\(request.groupId)"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .fetchMyGroup: return .qurey(nil)
        case .leaveGroup(let request): return .qurey(request)
        }
    }
}
