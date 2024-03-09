//
//  SearchRestaurantMapViewModel.swift
//  JMTeng
//
//  Created by PKW on 2024/02/04.
//

import Foundation

class SearchRestaurantMapViewModel {
    
    // MARK: - Properties
    // 데이터와 관련된 프로퍼티들을 선언하는 부분입니다.
    weak var coordinator: SearchRestaurantMapCoordinator?
    var info: SearchRestaurantsModel?
    
    // MARK: - Initialization
    // 뷰모델 초기화와 관련된 로직을 담당하는 부분입니다.
    
    // MARK: - Data Binding
    // 뷰와 뷰모델 간의 데이터 바인딩을 설정하는 부분입니다.
//    var didUpdateRestaurantRegistration: ((Bool?) -> Void)?
    
    // MARK: - Data Fetching
    // 외부 소스나 모델로부터 데이터를 가져오는 메소드들을 모아두는 부분입니다.
    func checkRegistrationRestaurant() async -> Bool? {
        
        do {
            let response = try await FetchRestaurantAPI.checkRegistrationRestaurantAsync(request: CheckRegistrationRestaurantRequest(kakaoSubId: info?.id ?? ""))
            return response.data ?? false
        } catch {
            print(error)
            return false
        }
    }
    
    // MARK: - Utility Methods
    // 다양한 유틸리티 메소드들을 모아두는 부분입니다. 예를 들어, 날짜 포매팅이나 데이터 검증 등입니다.
    
    // MARK: - Error Handling
    // 에러 처리와 관련된 로직을 담당하는 부분입니다.
}
