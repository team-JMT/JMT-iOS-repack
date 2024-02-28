//
//  RestaurantDetailDI.swift
//  JMTeng
//
//  Created by PKW on 2024/02/01.
//

import Foundation

import Swinject
import SwinjectStoryboard

struct RestaurantDetailDI: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(RestaurantDetailViewModel.self) { r in
            let viewModel = RestaurantDetailViewModel()
            return viewModel
        }
        
        container.register(DefaultPhotoAuthService.self) { r in
            let authService = DefaultPhotoAuthService()
            return authService
        }
        
        container.storyboardInitCompleted(RestaurantDetailViewController.self) { r, c in
            let viewModel = r.resolve(RestaurantDetailViewModel.self)!
            let photoAuthService = r.resolve(DefaultPhotoAuthService.self)!
            c.viewModel = viewModel
            c.viewModel?.photoAuthService = photoAuthService
        }
        
        container.register(RestaurantDetailInfoViewModel.self) { r in
            let viewModel = RestaurantDetailInfoViewModel()
            return viewModel
        }
        
        container.storyboardInitCompleted(RestaurantDetailInfoViewController.self) { r, c in
            let viewModel = r.resolve(RestaurantDetailInfoViewModel.self)!
            c.viewModel = viewModel
        }
        
        container.register(RestaurantDetailPhotoViewModel.self) { r in
            let viewModel = RestaurantDetailPhotoViewModel()
            return viewModel
        }
        
        container.storyboardInitCompleted(RestaurantDetailPhotoViewController.self) { r, c in
            let viewModel = r.resolve(RestaurantDetailPhotoViewModel.self)!
            c.viewModel = viewModel
        }
        
        container.register(RestaurantDetailReviewViewModel.self) { r in
            let viewModel = RestaurantDetailReviewViewModel()
            return viewModel
        }
        
        container.storyboardInitCompleted(RestaurantDetailReviewViewController.self) { r, c in
            let viewModel = r.resolve(RestaurantDetailReviewViewModel.self)!
            c.viewModel = viewModel
        }
    }
}
