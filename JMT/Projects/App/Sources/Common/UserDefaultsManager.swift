//
//  UserDefaultsManager.swift
//  JMTeng
//
//  Created by PKW on 2024/03/02.
//

import Foundation

struct UserDefaultManager {
    static let defaults = UserDefaults.standard
    
    struct Keys {
        static let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        static let isJoinGroup = "isJoinGroup"
        static let selectedGroupId = "selectedGroupId"
        static let recenLocationKeywords = "recenLocationKeywords"
        static let recentSearchRestaurantKeywords = "recentSearchRestaurantKeywords"
    }
    
    static var hasBeenLaunchedBeforeFlag: Bool {
        get { return defaults.bool(forKey: Keys.hasBeenLaunchedBeforeFlag) }
        set { defaults.setValue(newValue, forKey: Keys.hasBeenLaunchedBeforeFlag) }
    }
    
    static var isJoinGroup: Bool {
        get { return defaults.bool(forKey: Keys.isJoinGroup) }
        set { defaults.set(newValue, forKey: Keys.isJoinGroup) }
    }
    
    static var selectedGroupId: Int {
        get { return defaults.integer(forKey: Keys.selectedGroupId) }
        set { defaults.set(newValue, forKey: Keys.selectedGroupId) }
    }
}

extension UserDefaultManager {
    public static func isFirstLaunch() -> Bool {
        
        // 맨 처음 가져오면 false
        let isFirstLaunch = !hasBeenLaunchedBeforeFlag
        
        if isFirstLaunch {
            hasBeenLaunchedBeforeFlag = true
            defaults.synchronize()
        }
        
        return isFirstLaunch
    }
}

extension UserDefaultManager {
    
    static func saveSearchKeyword(_ keyword: String, type: String) {
        let defaults = UserDefaults.standard
        var searchKeywords: [String] = defaults.array(forKey: type) as? [String] ?? []
        
        // 중복 검색어 제거
        if let index = searchKeywords.firstIndex(of: keyword) {
            searchKeywords.remove(at: index)
        }
        
        // 새 검색어를 배열의 앞에 추가
        searchKeywords.insert(keyword, at: 0)
        
        // 최대 저장 개수 제한 (예: 10개)
        if searchKeywords.count > 10 {
            searchKeywords.removeLast()
        }
        
        // 변경된 배열 저장
        defaults.set(searchKeywords, forKey: type)
    }
    
    static func getRecentSearchKeywords(type: String) -> [String] {
        let defaults = UserDefaults.standard
        let searchKeywords: [String] = defaults.array(forKey: type) as? [String] ?? []
        return searchKeywords
    }
    
    static func removeAllSearchKeywords(type: String) {
        let defaults = UserDefaults.standard
          defaults.removeObject(forKey: type)
    }
    
    static func deleteSearchKeyword(_ keyword: String, type: String) {
        let defaults = UserDefaults.standard
        var searchKeywords: [String] = defaults.array(forKey: type) as? [String] ?? []
        
        // 해당 검색어를 배열에서 찾아 삭제
        if let index = searchKeywords.firstIndex(of: keyword) {
            searchKeywords.remove(at: index)
        }
        
        // 변경된 배열 저장
        defaults.set(searchKeywords, forKey: type)
    }
}
