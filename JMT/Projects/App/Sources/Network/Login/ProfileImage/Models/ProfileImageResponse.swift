//
//  ProfileImageResponse.swift
//  App
//
//  Created by PKW on 2024/01/16.
//

import Foundation

struct ProfileImageResponse: Decodable {
    let data: String?
    let message: String
    let code: String
}

extension ProfileImageResponse {
    var toDomain: ProfileImageModel {
        return ProfileImageModel(code: code)
    }
}
