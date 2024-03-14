//
//  SearchRestaurantViewModel.swift
//  JMTeng
//
//  Created by PKW on 2024/02/04.
//

import Foundation
import CoreLocation

class SearchRestaurantViewModel {

    // MARK: - Properties
    // 데이터와 관련된 프로퍼티들을 선언하는 부분입니다.
    weak var coordinator: SearchRestaurantCoordinator?
    var locationManager = LocationManager.shared
    
    var restaurantsInfo: [SearchRestaurantsLocationModel] = []
    var isSearch = false
   
    var isFetching = false
    var isEnd = false
    var currentPage = 1
    
    // MARK: - Initialization
    // 뷰모델 초기화와 관련된 로직을 담당하는 부분입니다.

    // MARK: - Data Binding
    // 뷰와 뷰모델 간의 데이터 바인딩을 설정하는 부분입니다.
    var onRestaurantsFetched: (([IndexPath]) -> Void)?
    
    // MARK: - Data Fetching
    // 외부 소스나 모델로부터 데이터를 가져오는 메소드들을 모아두는 부분입니다.
    func fetchSearchRestaurantsData(keyword: String) async throws {
        guard !isFetching && !isEnd else { return }
        isFetching = true
        
        do {
            let x = locationManager.coordinate?.longitude ?? 0.0
            let y = locationManager.coordinate?.latitude ?? 0.0
            
            let newRestaurants = try await FetchRestaurantAPI.fetchSearchRestaurantsAsync(request: SearchRestaurantsLocationRequest(query: keyword,
                                                                                                                                    page: currentPage,
                                                                                                                                    x: "\(x)",
                                                                                                                                    y: "\(y)"))
            
            let startIndex = restaurantsInfo.count
            let endIndex = startIndex + newRestaurants.count
            let indexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
            
            self.restaurantsInfo.append(contentsOf: newRestaurants)
            self.currentPage += 1
            self.isFetching = false
            self.isEnd = newRestaurants.count < 10
            self.onRestaurantsFetched?(indexPaths)
        } catch {
            self.isFetching = false
        }
    }
    
    // MARK: - Utility Methods
    // 다양한 유틸리티 메소드들을 모아두는 부분입니다. 예를 들어, 날짜 포매팅이나 데이터 검증 등입니다.

    // MARK: - Error Handling
    // 에러 처리와 관련된 로직을 담당하는 부분입니다.
}


