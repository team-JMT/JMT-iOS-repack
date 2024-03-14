//
//  SearchViewModel.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import Foundation

class SearchViewModel {
    weak var coordinator: SearchCoordinator?
    
    var recentSearchRestaurants = [String]()
    
    
    
    var recentResults = [String]()
    
    var currentSegIndex: Int = 0
    
    var isEmptyGroup: Bool = false
    
    func fetchGroups() async throws {
        
        
    }
    
}

// 5 9 12 15 16 17 18

// 최근 검색 관련 메소드
extension SearchViewModel {
    func fetchRecentSearchRestaurants() {
        recentSearchRestaurants = UserDefaultManager.getRecentSearchKeywords(type: UserDefaultManager.Keys.recentSearchRestaurantKeywords)
    }

    func saveRecentSearchRestaurants(keyword: String) {
        UserDefaultManager.saveSearchKeyword(keyword, type: UserDefaultManager.Keys.recentSearchRestaurantKeywords)
    }
    
    func deleteRecentSearchRestaurants(_ row: Int) {
        let keywoard = recentSearchRestaurants[row]
        recentSearchRestaurants.remove(at: row)
        UserDefaultManager.deleteSearchKeyword(keywoard, type: UserDefaultManager.Keys.recentSearchRestaurantKeywords)
    }
    
    func deleteAllRecentSearchRestaurants() {
        recentSearchRestaurants.removeAll()
        UserDefaultManager.removeAllSearchKeywords(type: UserDefaultManager.Keys.recentSearchRestaurantKeywords)
    }
}
