//
//  UpdateGroupTarget.swift
//  JMTeng
//
//  Created by PKW on 4/25/24.
//

import Foundation
import Alamofire

enum UpdateGroupTarget {
    case updateSelectedGroup(SelectedGroupRequest)
}

extension UpdateGroupTarget: TargetType {
    var method: Alamofire.HTTPMethod {
        switch self {
        case .updateSelectedGroup: return .post
        }
    }
    
    var path: String {
        switch self {
        case .updateSelectedGroup(let request): return "/group/\(request.groupId)/select"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .updateSelectedGroup: return .qurey(nil)
        }
    }
}
