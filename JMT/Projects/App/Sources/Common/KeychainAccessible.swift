//
//  TokenUtils.swift
//  App
//
//  Created by PKW on 2024/01/04.
//

import Foundation
import SwiftKeychainWrapper

protocol KeychainAccessible {
    func saveToken(_ key: String, _ value: String)
    func saveExpiresIn(_ key: String, _ value: Int)
    func getToken(_ key: String) -> String?
    func getExpiresIn(_ Key: String) -> Int?
    func remove(_ key: String)
    func removeAll()
}

class DefaultKeychainAccessible: KeychainAccessible {
    private let keychain = KeychainWrapper.standard
    
    func saveToken(_ key: String, _ value: String) {
        keychain.set(value, forKey: key)
    }
    
    func saveExpiresIn(_ key: String, _ value: Int) {
        keychain.set(value, forKey: key)
    }
    
    func getToken(_ key: String) -> String? {
        keychain.string(forKey: key)
    }
    
    func getExpiresIn(_ Key: String) -> Int? {
        keychain.integer(forKey: Key)
    }
    
    func remove(_ key: String) {
        keychain.removeObject(forKey: key)
    }
    
    func removeAll() {
        keychain.removeAllKeys()
    }
}
    
    
//    static func saveTokens(accessToken: String, refreshToken: String) {
//        UserDefaults.standard.set(accessToken, forKey: TokenType.accessToken.rawValue)
//        UserDefaults.standard.set(refreshToken, forKey: TokenType.refreshToken.rawValue)
//    }
//
//    static func saveAccessTokenExpiresIn(accessTokenExpiresIn: Int) {
//        UserDefaults.standard.set(accessTokenExpiresIn, forKey: TokenType.accessTokenExpiresIn.rawValue)
//    }
//
//    static func getAccessToken() -> String? {
//        return UserDefaults.standard.string(forKey: TokenType.accessToken.rawValue)
//    }
//
//    static func getRefreshToken() -> String? {
//        return UserDefaults.standard.string(forKey: TokenType.refreshToken.rawValue)
//    }
//
//    static func getAccessTokenExpiresIn() -> Int? {
//        return UserDefaults.standard.integer(forKey: TokenType.accessTokenExpiresIn.rawValue)
//    }
//
//}
