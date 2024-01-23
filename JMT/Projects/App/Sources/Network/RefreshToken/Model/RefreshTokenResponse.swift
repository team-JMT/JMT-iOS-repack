//
//  RefreshTokenResponse.swift
//  JMTeng
//
//  Created by PKW on 2024/01/19.
//

import Foundation

struct RefreshTokenResponse: Decodable {
    let data: RefreshTokenData
    
    struct RefreshTokenData: Decodable {
        let grantType: String
        let accessToken: String
        let refreshToken: String
        let accessTokenExpiresIn: Int
        let userLoginAction: String
    }
    
    let message: String
    let code: String
}

extension RefreshTokenResponse {
    var toDomain: RefreshTokenModel {
        return RefreshTokenModel(accessToken: data.accessToken,
                                 refreshToken: data.refreshToken,
                                 accessTokenExpiresIn: data.accessTokenExpiresIn)
    }
}
