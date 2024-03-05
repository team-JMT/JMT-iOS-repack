//
//  SearchRestaurantMapViewModel.swift
//  JMTeng
//
//  Created by PKW on 2024/02/04.
//

import Foundation

class SearchRestaurantMapViewModel {
    weak var coordinator: SearchRestaurantMapCoordinator?
    
    var didUpdateRestaurantRegistration: ((Bool?) -> Void)?
    
    
    var filterType: Int = 0
    var info: SearchRestaurantsLocationModel?
    
    func checkRestaurantRegistration() {
        CheckRestaurantRegistrationAPI.checkRestaurantRegistration(request: CheckRestaurantRegistrationRequest(kakaoSubId: info?.id ?? "")) { response in
            switch response {
            case .success(let success):
                self.didUpdateRestaurantRegistration?(success.data)
            case .failure(let failure):
                print("SearchRestaurantMapViewModel - checkRestaurantRegistrationError", failure)
            }
        }
    }
}
