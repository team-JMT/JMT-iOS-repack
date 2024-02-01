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
    var resultLocations = [String]()
    
    var isSearch = false

    var enterPoint: Int = 0

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
                self.getSearchLocations()
            }
        }
        
        self.workItem = workItem
        
        DispatchQueue.main.asyncAfter(deadline:  .now() + 0.5 , execute: workItem)
    }
    
    func getSearchLocations() {
        UserLocationAPI.getSearchLocations { result in
            self.resultLocations = result
            self.onSuccess?()
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
