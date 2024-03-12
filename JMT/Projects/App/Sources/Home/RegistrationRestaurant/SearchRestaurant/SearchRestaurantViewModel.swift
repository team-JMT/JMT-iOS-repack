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
    var locationManager = LocationManager()
    var location: CLLocationCoordinate2D?
    
    var restaurantsInfo: [SearchRestaurantsModel] = []
    
    // MARK: - Initialization
    // 뷰모델 초기화와 관련된 로직을 담당하는 부분입니다.

    // MARK: - Data Binding
    // 뷰와 뷰모델 간의 데이터 바인딩을 설정하는 부분입니다.
    var didUpdateRestaurantsInfo: (() -> Void)?
    
    // MARK: - Data Fetching
    // 외부 소스나 모델로부터 데이터를 가져오는 메소드들을 모아두는 부분입니다.
    func fetchSearchRestaurants(keyword: String, x: String, y: String) async throws {
        
        let result = try await FetchRestaurantAPI.fetchSearchRestaurantsAsync(request: SearchRestaurantsRequest(query: keyword, page: 1, x: x, y: y))
        restaurantsInfo.append(contentsOf: result)
    }
    
    // MARK: - Utility Methods
    // 다양한 유틸리티 메소드들을 모아두는 부분입니다. 예를 들어, 날짜 포매팅이나 데이터 검증 등입니다.

    // MARK: - Error Handling
    // 에러 처리와 관련된 로직을 담당하는 부분입니다.
}


