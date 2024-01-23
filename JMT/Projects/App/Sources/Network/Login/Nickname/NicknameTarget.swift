//
//  NicknameTarget.swift
//  App
//
//  Created by PKW on 2024/01/03.
//

import Foundation
import Alamofire

enum NicknameTarget {
    case checkDuplicate(NicknameRequest)
    case saveNickname(NicknameRequest)
}

extension NicknameTarget: TargetType {
    var method: HTTPMethod {
        switch self {
        case .checkDuplicate: return .get
        case .saveNickname: return .post
        }
    }
    
    var path: String {
        switch self {
        case .checkDuplicate(let request): return "/user/\(request.nickname)"
        case .saveNickname: return "/user/nickname"
        }
    }
   
    var parameters: RequestParams {
        switch self {
        case .checkDuplicate(let request): return .qurey(request)
        case .saveNickname(let request): return .body(request)
        }
    }
}
