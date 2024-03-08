//
//  RestaurantDetailViewModel.swift
//  JMTeng
//
//  Created by PKW on 2024/02/01.
//

import Foundation
import UIKit

class RestaurantDetailViewModel {
    weak var coordinator: RestaurantDetailCoordinator?
    
    var photoAuthService: PhotoAuthService?
    
    var restaurantInfo: SearchMapRestaurantItems?
    var currentSegIndex: Int = 0
    var reviewImages = [UIImage]()
    
    var didUpdateReviewImage: (() -> Void)?
    
    func updateReviewImages(images: [UIImage]) {
        reviewImages.append(contentsOf: images)
        didUpdateReviewImage?()
    }
}
