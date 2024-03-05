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
    
    var isSearch = false
    
    var currentPage = 1
    var isFetching = false
    var isEnd = false
    
    var workItem: DispatchWorkItem?
    
    var onSuccess: (() -> Void)?
}

// 검색 관련 메소드
extension UserLocationViewModel {
    
//    func didChangeTextField(keyword: String) {
//        resetSearchState()
//
//        workItem?.cancel()
//
//        workItem = DispatchWorkItem { [weak self] in
//            guard let self = self, !keyword.isEmpty else {
//                self?.onSuccess?()
//                return
//            }
//
//            self.handleTextChange(keyword: keyword)
//        }
//
//        if let workItem = workItem {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
//        }
//    }
    
    func handleTextChange(keyword: String) {
        fetchSearchLocation(keyword: keyword)
        saveRecentLocation(keyword: keyword)
        fetchRecentLocations()
    }
    
    func fetchSearchLocation(keyword: String) {
        guard !isFetching && !isEnd else { return }
        
        isFetching = true
        
        SearchLocationAPI.getSearchLocations(request: SearchLocationRequest(query: keyword, page: currentPage)) { [weak self] response in
            guard let self = self else { return }
            self.isFetching = false
            
            switch response {
            case .success(let locations):
                self.resultLocations.append(contentsOf: locations)
                self.isEnd = locations.isEmpty
            case .failure(let failure):
                self.isEnd = true
            }
            self.onSuccess?()
        }
    }
    
    func resetSearchState() {
        currentPage = 1
        isEnd = false
        resultLocations.removeAll()
    }
}

// 최근 검색어 관련 메소드
extension UserLocationViewModel {
    
    func fetchRecentLocations() {
        recentLocations = DefaultUserDefaultService.getRecentSearchKeywords()
        onSuccess?()
    }

    func saveRecentLocation(keyword: String) {
        DefaultUserDefaultService.saveSearchKeyword(keyword)
    }
    
    func deleteRecentLocation(_ row: Int) {
        let keywoard = recentLocations[row]
        recentLocations.remove(at: row)
        DefaultUserDefaultService.deleteSearchKeyword(keywoard)
        onSuccess?()
    }
    
    func deleteAllRecentLocation() {
        recentLocations.removeAll()
        DefaultUserDefaultService.removeAllSearchKeywords()
        onSuccess?()
    }
}
