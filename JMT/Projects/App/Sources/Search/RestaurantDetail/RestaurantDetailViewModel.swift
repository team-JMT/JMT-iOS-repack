//
//  RestaurantDetailViewModel.swift
//  JMTeng
//
//  Created by PKW on 2024/02/01.
//

import Foundation
import UIKit
import CoreLocation

struct StickyHeaderViewConfig {
    let initialHeight: CGFloat
    let finalHeight: CGFloat
    var heightConstraintRange: ClosedRange<CGFloat> {
        return finalHeight...initialHeight
    }

    init(initialHeight: CGFloat, finalHeight: CGFloat) {
        self.initialHeight = initialHeight
        self.finalHeight = finalHeight
    }
}

class RestaurantDetailViewModel {
    
    deinit {
        print("RestaurantDetailViewModel Deinit")
    }
    
    // MARK: - Properties
    // 데이터와 관련된 프로퍼티들을 선언하는 부분입니다.
    weak var coordinator: RestaurantDetailCoordinator?
    
    let stickyHeaderViewConfig = StickyHeaderViewConfig(initialHeight: 200, finalHeight: 0)
    let locationManager = LocationManager.shared

    var recommendRestaurantId: Int?
    var restaurantData: DetailRestaurantModel?
    var restaurantReviewImages: [String] = []
    
    var currentSegIndex: Int = 0
    var reviewImages = [UIImage]()
    
    // MARK: - Initialization
    // 뷰모델 초기화와 관련된 로직을 담당하는 부분입니다.
    
    // MARK: - Data Binding
    // 뷰와 뷰모델 간의 데이터 바인딩을 설정하는 부분입니다.
    var didCompletedRestaurant: (() -> Void)?
    var didUpdateReviewImage: (() -> Void)?
    var didUpdateSeg: ((Int) -> Void)?
    
    // MARK: - Data Fetching
    // 외부 소스나 모델로부터 데이터를 가져오는 메소드들을 모아두는 부분입니다.
    
    // 위치 정보 가져오기
    func fetchCurrentLocationAsync() async {
        
        return await withCheckedContinuation { continuation in
            locationManager.didUpdateLocations = {
                continuation.resume()
            }
            
            locationManager.startUpdateLocation()
        }
    }
    
    // 맛집 정보 가져오기
    func fetchRestaurantData() async throws {
        let x = locationManager.coordinate?.longitude ?? 0.0
        let y = locationManager.coordinate?.latitude ?? 0.0
        
        restaurantData = try await FetchRestaurantAPI.fetchDetailRestaurantAsync(request: DetailRestaurantRequest(recommendRestaurantId: recommendRestaurantId ?? 0, coordinator: DetailRestaurantCoordinate(x: "\(x)", y: "\(y)"))).toDomain
    }
    
    func fetchRestaurantReviewData() async throws {
        restaurantData?.reviews = try await FetchRestaurantAPI.fetchRestaurantReviews(request: RestaurantReviewRequest(recommendRestaurantId: recommendRestaurantId ?? 0)).toDomain
        
        if let reviews = restaurantData?.reviews {
            reviews.map({ review in
                restaurantReviewImages.append(contentsOf: review.reviewImages)
            })
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
