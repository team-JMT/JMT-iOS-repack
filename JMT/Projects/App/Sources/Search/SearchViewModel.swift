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
    
    var onSuccess: (() -> ())?
    
    var tagData = ["1","2","33","444","5555"]
    
    var recentArray = ["식당1","식당2","식당3","음식점1","음식정2","음식점3"]
    
    var recentResults = [String]()
    
    var isSearch: Bool = false
    
    var currentSegIndex: Int = 0
    
    var workItem: DispatchWorkItem?
    
    func didChangeTextField(text: String) {
        workItem?.cancel()
        
        let workItem = DispatchWorkItem {
            self.recentResults.removeAll()
            self.recentResults = self.recentArray.filter({$0.contains(text)})
            self.onSuccess?()
        }
        
        self.workItem = workItem
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }
}

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
