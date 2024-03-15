//
//  SearchViewModel.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import Foundation

class SearchViewModel {
    weak var coordinator: SearchCoordinator?
    let locationManager = LocationManager.shared
    
    var recentSearchRestaurants = [String]()
    var currentSegIndex: Int = 0
    var isEmptyGroup: Bool = UserDefaultManager.selectedGroupId == nil ? true : false
    
    var groupList = [SearchGroupItems]()
    var restaurants = [SearchRestaurantsItems]()
    var outBoundrestaurants = [SearchRestaurantsOutBoundItems]()
    
    var didUpdateGroup: (() -> Void)?
    
    
    func fetchGroups(keyword: String) async throws {
        groupList.removeAll()
        let data = try await GroupAPI.fetchGroups(request: SearchGroupRequest(keyword: keyword)).data.groupList
        groupList.append(contentsOf: data)
    }
    
    func fetchRestaurants(keyword: String) async throws {
        restaurants.removeAll()
        let x = locationManager.coordinate?.longitude ?? 0.0
        let y = locationManager.coordinate?.latitude ?? 0.0
        let data = try await FetchRestaurantAPI.fetchSearchRestaurantsAsync(request: SearchRestaurantsRequest(keyword: keyword, x: "\(x)", y: "\(y)")).data
        
        restaurants.append(contentsOf: data)
    }
    
    func fetchOutBoundRestaurants(keyword: String) async throws {
        outBoundrestaurants.removeAll()
        let data = try await FetchRestaurantAPI.fetchSearchRestaurantsOutBoundAsync(request: SearchRestaurantsOutBoundRequest(keyword: keyword, currentGroupId: nil)).data
        
        outBoundrestaurants.append(contentsOf: data)
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
