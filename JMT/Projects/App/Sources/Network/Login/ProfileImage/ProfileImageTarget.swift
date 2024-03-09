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
}

extension ProfileImageTarget: TargetType {
    var method: HTTPMethod {
        switch self {
        case .saveProfileImage: return .post
        case .saveDefaultProfileImage: return .post
        }
    }
    
    var path: String {
        switch self {
        case .saveProfileImage: return "/user/profileImg"
        case .saveDefaultProfileImage: return "/user/defaultProfileImg"
        }
    }

    var parameters: RequestParams {
        switch self {
//        case .saveProfileImage(let request): return .body(request)
        case .saveProfileImage: return .body(nil)
        case .saveDefaultProfileImage: return .qurey(nil)
        }
    }
}
