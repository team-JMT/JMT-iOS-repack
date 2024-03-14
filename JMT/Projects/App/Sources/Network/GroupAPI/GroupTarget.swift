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
    case fetchGroups(SearchGroupRequest)
    case leaveGroup(MyGroupRequest)
    case updateSelectedGroup(SelectedGroupRequest)
}

extension GroupTarget: TargetType {
    var method: HTTPMethod {
        switch self {
        case .fetchMyGroup: return .get
        case .fetchGroups: return .post
        case .leaveGroup: return .delete
        case .updateSelectedGroup: return .post
        }
    }
    
    var path: String {
        switch self {
        case .fetchMyGroup: return "/group/my"
        case .fetchGroups: return "/group/search"
        case .leaveGroup(let request): return "/group/\(request.groupId)"
        case .updateSelectedGroup(let request): return "/group/\(request.groupId)/select"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .fetchMyGroup: return .qurey(nil)
        case .fetchGroups(let request): return .body(request)
        case .leaveGroup(let request): return .qurey(request)
        case .updateSelectedGroup: return .qurey(nil)
        }
    }
}
