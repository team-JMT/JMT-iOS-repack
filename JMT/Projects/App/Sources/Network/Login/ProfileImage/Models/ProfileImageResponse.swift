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
        return ProfileImageModel(message: message)
    }
}


struct CurrentLoginInfoResponse<T:Decodable>: Decodable {
    let data: T
    let message: String
    let code: String
}

struct CurrentLoginInfoData: Decodable {
    let id: Int
    let email: String
    let nickname: String
    let profileImg: String
}

