//
//  SocialLoginRequest.swift
//  App
//
//  Created by PKW on 2024/01/03.
//

import Foundation

struct SocialLoginRequest: Encodable {
    let token: String
}

struct LogoutRequest: Encodable {
    let accessToken: String
    let refreshToken: String
}

