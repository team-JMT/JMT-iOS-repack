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
    var isEmptyGroup: Bool?
    
    var restaurants = [SearchRestaurantsItems]()
    var groupList = [SearchGroupItems]()
    var outBoundrestaurants = [SearchRestaurantsOutBoundModel]()
    
    var didUpdateSegIndex: ((Int) -> Void)?

    // 맛집 검색하기
    func fetchRestaurantsAsync(keyword: String) async throws {
        do {
            restaurants.removeAll()
            
            let x = locationManager.coordinate?.longitude ?? 0.0
            let y = locationManager.coordinate?.latitude ?? 0.0
            let response = try await FetchRestaurantAPI.fetchSearchRestaurantsAsync(request: SearchRestaurantsRequest(keyword: keyword, x: "\(x)", y: "\(y)"))
            
//            restaurants.append(contentsOf: response.data.restaurants)
            restaurants = response.data.restaurants
        } catch {
            print(error)
            throw RestaurantError.fetchRestaurantsAsyncError
        }
    }
    
    // 그룹 검색하기
    func fetchGroupsAsync(keyword: String) async throws {
        do {
            groupList.removeAll()
            
            let response = try await GroupAPI.fetchGroups(request: SearchGroupRequest(keyword: keyword))
//            groupList.append(contentsOf: response.data.groupList)
            groupList = response.data.groupList
        } catch {
            print(error)
            throw RestaurantError.fetchGroupsAsyncError
        }
    }

    // 다른 그룹 맛집 데이터 검색하기
    func fetchOutBoundRestaurantsAsync(keyword: String) async throws {
        
        do {
            outBoundrestaurants.removeAll()
            
            let response = try await FetchRestaurantAPI.fetchSearchRestaurantsOutBoundAsync(request: SearchRestaurantsOutBoundRequest(keyword: keyword, currentGroupId: -1))
            outBoundrestaurants = response.toDomain
        } catch {
            print(error)
            throw RestaurantError.fetchOutBoundRestaurantsAsyncError
        }
    }
}


// 35 36 37 38
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
