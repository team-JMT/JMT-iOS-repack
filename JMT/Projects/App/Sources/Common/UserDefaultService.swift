//
//  DefaultUserDefaultService.swift
//  JMTeng
//
//  Created by PKW on 2024/02/14.
//

import Foundation

class DefaultUserDefaultService {
    static func saveSearchKeyword(_ keyword: String) {
        let defaults = UserDefaults.standard
        var searchKeywords: [String] = defaults.array(forKey: "recentSearchKeywords") as? [String] ?? []
        
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
        defaults.set(searchKeywords, forKey: "recentSearchKeywords")
    }
    
    static func getRecentSearchKeywords() -> [String] {
        let defaults = UserDefaults.standard
        let searchKeywords: [String] = defaults.array(forKey: "recentSearchKeywords") as? [String] ?? []
        return searchKeywords
    }
    
    static func removeAllSearchKeywords() {
        let defaults = UserDefaults.standard
          defaults.removeObject(forKey: "recentSearchKeywords")
    }
    
    static func deleteSearchKeyword(_ keyword: String) {
        let defaults = UserDefaults.standard
        var searchKeywords: [String] = defaults.array(forKey: "recentSearchKeywords") as? [String] ?? []
        
        // 해당 검색어를 배열에서 찾아 삭제
        if let index = searchKeywords.firstIndex(of: keyword) {
            searchKeywords.remove(at: index)
        }
        
        // 변경된 배열 저장
        defaults.set(searchKeywords, forKey: "recentSearchKeywords")
    }
}

