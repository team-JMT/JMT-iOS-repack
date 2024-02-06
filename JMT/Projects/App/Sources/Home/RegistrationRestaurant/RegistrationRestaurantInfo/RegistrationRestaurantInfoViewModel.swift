//
//  RegistrationRestaurantInfoViewModel.swift
//  JMTeng
//
//  Created by PKW on 2024/02/04.
//

import Foundation

class RegistrationRestaurantInfoViewModel {
    weak var coordinator: RegistrationRestaurantInfoCoordinator?
    
    var didCompleted: (() -> Void)?
    
    var filterType: Int = 0 {
        didSet {
            didCompleted?()
        }
    }

    var selectedImages: [PhotoInfo] = []
}
