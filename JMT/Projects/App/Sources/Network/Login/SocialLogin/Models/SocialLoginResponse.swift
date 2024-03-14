//
//  SocialLoginResponse.swift
//  App
//
//  Created by PKW on 2024/01/03.
//

import Foundation

struct SocialLoginResponse: Decodable {
    let data: SocialLoginData
    let message: String
    let code: String
}

struct SocialLoginData: Decodable {
    let grantType: String
    let accessToken: String
    let refreshToken: String
    let accessTokenExpiresIn: Int
    let userLoginAction: String
}

extension SocialLoginResponse {
    var toDomain: SocialLoginModel {
        return SocialLoginModel(accessToken: data.accessToken,
                                refreshToken: data.refreshToken,
                                userLoginAction: data.userLoginAction, 
                                accessTokenExpiresIn: data.accessTokenExpiresIn)
    }
}


struct LogoutResponse: Decodable {
    let data: String
    let message: String
    let code: String
}
