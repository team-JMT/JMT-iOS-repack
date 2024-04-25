//
//  UserLocationViewModel.swift
//  JMTeng
//
//  Created by PKW on 2024/01/19.
//

import Foundation

class UserLocationViewModel {
    weak var coordinator: UserLocationCoordinator?
    
    var recentLocations = [String]()
    var resultLocations = [SearchLocationModel]()
    
    var enterPoint = 0
    
    var fetchTask: Task<Void, Never>?
    
    var isSearch = false
    
    var isDataLoading = false
    var currentPage = 1
    var hasMoreData = true
    
    var onSuccess: (() -> Void)?
}

// 검색 관련 메소드
extension UserLocationViewModel {
    
    func handleTextChange(keyword: String) {
        fetchSearchLocation(keyword: keyword)
        saveRecentLocation(keyword: keyword)
        fetchRecentLocations()
    }
    
    func fetchSearchLocation(keyword: String) {
        
        let fetchPage = currentPage
        guard !isDataLoading else { return }
        isDataLoading = true
        
        fetchTask = Task {
            do {
                let newData = try await LocationAPI.getSearchLocations(request: SearchLocationRequest(query: keyword, page: currentPage)).toDomain
                
                DispatchQueue.main.async {
                    if fetchPage == self.currentPage { // 현재 페이지가 요청 페이지와 일치할 때만 업데이트
                        
                        if let lastNewItem = newData.last, self.resultLocations.contains(where: { $0.placeName == lastNewItem.placeName} ) {
                            self.hasMoreData = false
                        } else {
                            self.resultLocations.append(contentsOf: newData)
                            self.currentPage += 1
                        }
                    }
                    
                    self.isDataLoading = false
                    self.fetchTask = nil
                    self.onSuccess?()
                }
            } catch {
                DispatchQueue.main.async {
                    print(error)
                    self.isDataLoading = false
                    self.fetchTask = nil
                    self.onSuccess?()
                }
            }
        }
    }
    
    func cancelFetch() {
        if let task = fetchTask {
            task.cancel()
            fetchTask = nil
            isDataLoading = false
        }
    }

    func resetSearchState() {
        currentPage = 1
        hasMoreData = false
        resultLocations.removeAll()
    }
}

// 최근 검색어 관련 메소드
extension UserLocationViewModel {
    
    func fetchRecentLocations() {
        recentLocations = UserDefaultManager.getRecentSearchKeywords(type: UserDefaultManager.Keys.recenLocationKeywords)
        onSuccess?()
    }

    func saveRecentLocation(keyword: String) {
        UserDefaultManager.saveSearchKeyword(keyword, type: UserDefaultManager.Keys.recenLocationKeywords)
    }
    
    func deleteRecentLocation(_ row: Int) {
        let keywoard = recentLocations[row]
        recentLocations.remove(at: row)
        UserDefaultManager.deleteSearchKeyword(keywoard, type: UserDefaultManager.Keys.recenLocationKeywords)
        onSuccess?()
    }
    
    func deleteAllRecentLocation() {
        recentLocations.removeAll()
        UserDefaultManager.removeAllSearchKeywords(type: UserDefaultManager.Keys.recenLocationKeywords)
        onSuccess?()
    }
}
