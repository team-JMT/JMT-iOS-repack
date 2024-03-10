//
//  RestaurantDetailViewModel.swift
//  JMTeng
//
//  Created by PKW on 2024/02/01.
//

import Foundation
import UIKit

class RestaurantDetailViewModel {
    
    // MARK: - Properties
    // 데이터와 관련된 프로퍼티들을 선언하는 부분입니다.
    weak var coordinator: RestaurantDetailCoordinator?
//    var locationManager = LocationManager()

    var restauranId: Int?
    
    var currentSegIndex: Int = 0
    var reviewImages = [UIImage]()
    
    // MARK: - Initialization
    // 뷰모델 초기화와 관련된 로직을 담당하는 부분입니다.
    
    // MARK: - Data Binding
    // 뷰와 뷰모델 간의 데이터 바인딩을 설정하는 부분입니다.
    var didUpdateReviewImage: (() -> Void)?
    
    // MARK: - Data Fetching
    // 외부 소스나 모델로부터 데이터를 가져오는 메소드들을 모아두는 부분입니다.
    func fetchRestaurantData() {
        Task {
            do {
//                locationManager.didUpdateLocations = { location in
//                    print(location)
//                }
//                let restaurant = try await FetchRestaurantAPI.fetchDetailRestaurantAsync(request: DetailRestaurantRequest(recommendRestaurantId: restauranId, coordinator: <#T##DetailRestaurantCoordinate#>))
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - Utility Methods
    // 다양한 유틸리티 메소드들을 모아두는 부분입니다. 예를 들어, 날짜 포매팅이나 데이터 검증 등입니다.
    
    // MARK: - Error Handling
    // 에러 처리와 관련된 로직을 담당하는 부분입니다.

    
    
    func updateReviewImages(images: [UIImage]) {
        reviewImages.append(contentsOf: images)
        didUpdateReviewImage?()
    }
}
