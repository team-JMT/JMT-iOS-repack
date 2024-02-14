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
    
    var enterPoint: Int = 0
    
    var isSearch = false
    
    var currentPage: Int = 1
    var isFetching = false
    var isEnd = false
    

    var workItem: DispatchWorkItem?
    
    var onSuccess: (() -> ())?
    
    func didChangeTextField(text: String) {
        
        workItem?.cancel()
        
        let workItem = DispatchWorkItem {
            
            if text.isEmpty {
                self.isSearch = false
                self.resultLocations.removeAll()
                self.getRecentLocations()
                self.onSuccess?()
            } else {
                self.isSearch = true
                self.saveRecentLocation(text: text)
                self.resultLocations.removeAll()
                //self.getSearchLocations(text: text)
                self.fetchSearchLocations(text: text)
            }
        }
        
        self.workItem = workItem
        
        DispatchQueue.main.asyncAfter(deadline:  .now() + 0.5 , execute: workItem)
    }
    
    func fetchSearchLocations(text: String) {
        print(currentPage)
        
        guard !isFetching, !isEnd else { return }
        
        isSearch = true
        isFetching = true
        
        SearchLocationAPI.getSearchLocations(request: SearchLocationRequest(query: text, page: currentPage)) { response in
            switch response {
            case .success(let locations):
                
                self.isFetching = false
                self.resultLocations.append(contentsOf: locations)
                self.onSuccess?()
                
                self.currentPage += 1
                
                if locations.isEmpty {
                    self.isEnd = true
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getSearchLocations(text: String) {
        
        isSearch = true
        
        SearchLocationAPI.getSearchLocations(request: SearchLocationRequest(query: text, page: currentPage)) { response in
            
            switch response {
            case .success(let locations):
                self.resultLocations.append(contentsOf: locations)
                self.onSuccess?()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func saveRecentLocation(text: String) {
        DefaultUserDefaultService.saveSearchKeyword(text)
    }
    
    func getRecentLocations() {
        isSearch = false
        recentLocations = DefaultUserDefaultService.getRecentSearchKeywords()
        onSuccess?()
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
