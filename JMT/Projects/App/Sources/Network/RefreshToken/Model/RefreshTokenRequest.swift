//
//  RefreshTokenRequest.swift
//  JMTeng
//
//  Created by PKW on 2024/01/19.
//

import Foundation

struct RefreshTokenRequest: Encodable {
    let accessToken: String
    let refreshToken: String
}
