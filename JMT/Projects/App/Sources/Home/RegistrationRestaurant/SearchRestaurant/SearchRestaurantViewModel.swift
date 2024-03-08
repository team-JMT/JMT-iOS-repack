//
//  SearchRestaurantViewModel.swift
//  JMTeng
//
//  Created by PKW on 2024/02/04.
//

import Foundation

class SearchRestaurantViewModel {
    weak var coordinator: SearchRestaurantCoordinator?
    
    var locationManager = LocationManager.shared
    
    var filterType: Int = 0
    
    var restaurantsInfo: [SearchRestaurantsLocationModel] = []
    
    var didUpdateRestaurantsInfo: (() -> Void)?
    
    func fetchRestaurantsInfo(keyword: String) {
        
        let x = locationManager.currentLocation?.longitude ?? 0.0
        let y = locationManager.currentLocation?.latitude ?? 0.0
        
        SearchRestaurantsLocationAPI.getSearchRestaurantsLocation(request: SearchRestaurantsLocationRequest(query: keyword, page: 1, x: String(x), y: String(y))) { response in
            switch response {
            case .success(let infos):
                
                print(infos)
                
                self.restaurantsInfo.append(contentsOf: infos)
                self.didUpdateRestaurantsInfo?()
            case .failure(let error):
                print(error)
            }
        }
    }
}
//
