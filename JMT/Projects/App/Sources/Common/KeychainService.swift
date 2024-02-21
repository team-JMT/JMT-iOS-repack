//
//  KeychainService.swift
//  JMTeng
//
//  Created by PKW on 2024/01/19.
//

import Foundation

protocol KeychainService {
    var accessToken: String? { get set }
    var refreshToken: String? { get set }
    var accessTokenExpiresIn: Int? { get set }
}

class DefaultKeychainService: KeychainService {
    static let shared = DefaultKeychainService()
    private init() {}
    
    private let keychainAccess = DefaultKeychainAccessible()
    
    struct Key {
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
        static let accessTokenExpiresIn = "accessTokenExpiresIn"
    }
    
    
    var accessToken: String? {
        get {
            keychainAccess.getToken(Key.accessToken)
        }
        set {
            if newValue != nil {
                keychainAccess.saveToken(Key.accessToken, newValue ?? "")
            } else {
                keychainAccess.remove(Key.accessToken)
            }
        }
    }
    
    var refreshToken: String? {
        get {
            keychainAccess.getToken(Key.refreshToken)
        }
        set {
            if newValue != nil {
                keychainAccess.saveToken(Key.refreshToken, newValue ?? "")
            } else {
                keychainAccess.remove(Key.refreshToken)
            }
        }
    }
    
    var accessTokenExpiresIn: Int? {
        get {
            keychainAccess.getExpiresIn(Key.accessTokenExpiresIn)
        }
        set {
            if newValue != nil {
                keychainAccess.saveExpiresIn(Key.accessTokenExpiresIn, newValue ?? 0)
            } else {
                keychainAccess.remove(Key.accessTokenExpiresIn)
            }
        }
    }
}
