//
//  UserLocationViewModel.swift
//  JMTeng
//
//  Created by PKW on 2024/01/19.
//

import Foundation

class UserLocationViewModel {
    weak var coordinator: UserLocationCoordinator?
    
    var onSuccess: (() -> ())?
    
    var recentLocations = [String]()
    var resultLocations = [SearchLocationModel]()
    
    var isSearch = false

    var enterPoint: Int = 0
    var currentPage: Int = 1

    var workItem: DispatchWorkItem?
    
    func didChangeTextField(text: String) {
        
        workItem?.cancel()
        
        let workItem = DispatchWorkItem {
            
            if text.isEmpty {
                self.isSearch = false
                self.resultLocations.removeAll()
                self.onSuccess?()
            } else {
                self.isSearch = true
                self.recentLocations.append(text)
                self.resultLocations.removeAll()
                self.getSearchLocations(text: text)
            }
        }
        
        self.workItem = workItem
        
        DispatchQueue.main.asyncAfter(deadline:  .now() + 0.5 , execute: workItem)
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
    
    func getRecentLocations() {
        isSearch = false
        recentLocations = ["동대문","1","2","3","4","5","6"]
        onSuccess?()
    }
    
    func deleteRecentLocation(index: IndexPath) {
        recentLocations.remove(at: index.row)
        onSuccess?()
    }
    
    func deleteAllRecentLocation() {
        recentLocations.removeAll()
        onSuccess?()
    }
}
