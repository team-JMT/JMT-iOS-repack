//
//  ProfileImageTarget.swift
//  App
//
//  Created by PKW on 2024/01/16.
//

import Foundation
import Alamofire

enum ProfileImageTarget {
    case saveProfileImage(ProfileImageReqeust)
    case saveDefaultProfileImage
    case getLoginInfo
}

extension ProfileImageTarget: TargetType {
    var method: HTTPMethod {
        switch self {
        case .saveProfileImage: return .post
        case .saveDefaultProfileImage: return .post
        case .getLoginInfo: return .get
        }
    }
    
    var path: String {
        switch self {
        case .saveProfileImage: return "/user/profileImg"
        case .saveDefaultProfileImage: return "/user/defaultProfileImg"
        case .getLoginInfo: return "/user/info"
        }
    }

    var parameters: RequestParams {
        switch self {
        case .saveProfileImage(let request): return .body(request)
        case .saveDefaultProfileImage: return .qurey(nil)
        case .getLoginInfo: return .qurey(nil)
        }
    }
    
    var needsBearer: Bool {
        switch self {
        case .saveProfileImage: return true
        case .saveDefaultProfileImage: return true
        case .getLoginInfo: return true
        }
    }
}
