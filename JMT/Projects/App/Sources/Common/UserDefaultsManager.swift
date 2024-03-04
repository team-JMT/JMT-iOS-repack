//
//  UserDefaultsManager.swift
//  JMTeng
//
//  Created by PKW on 2024/03/02.
//

import Foundation

struct UserDefaultManager {
    private static let defaults = UserDefaults.standard
    
    private struct Keys {
        static let hasLaunchedBefore = "hasLaunchedBefore"
        static let hasLocationRequstBefore = "hasLocationRequstBefore"
    }
    
    static var hasLaunchedBefore: Bool {
        get { return defaults.bool(forKey: Keys.hasLaunchedBefore) }
        set { defaults.set(newValue, forKey: Keys.hasLaunchedBefore) }
    }
    
    static var hasLocationRequstBefore: Bool {
        get { return defaults.bool(forKey: Keys.hasLocationRequstBefore) }
        set { defaults.set(newValue, forKey: Keys.hasLocationRequstBefore) }
    }
}

