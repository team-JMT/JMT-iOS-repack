//
//  TokenUtils.swift
//  App
//
//  Created by PKW on 2024/01/04.
//

import Foundation

enum TokenType: String {
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
    case accessTokenExpiresIn = "accessTokenExpiresIn"
}

// 추후 키체인으로 변경 예정
class TokenUtils {
    static func saveTokens(accessToken: String, refreshToken: String) {
        UserDefaults.standard.set(accessToken, forKey: TokenType.accessToken.rawValue)
        UserDefaults.standard.set(refreshToken, forKey: TokenType.refreshToken.rawValue)
    }
    
    static func saveAccessTokenExpiresIn(accessTokenExpiresIn: Int) {
        UserDefaults.standard.set(accessTokenExpiresIn, forKey: TokenType.accessTokenExpiresIn.rawValue)
    }
    
    static func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: TokenType.accessToken.rawValue)
    }
    
    static func getRefreshToken() -> String? {
        return UserDefaults.standard.string(forKey: TokenType.refreshToken.rawValue)
    }
    
    static func getAccessTokenExpiresIn() -> Int? {
        return UserDefaults.standard.integer(forKey: TokenType.accessTokenExpiresIn.rawValue)
    }
    
}
