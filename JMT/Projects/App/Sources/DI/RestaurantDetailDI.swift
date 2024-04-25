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
        
        container.storyboardInitCompleted(RestaurantDetailViewController.self) { r, c in
            let viewModel = r.resolve(RestaurantDetailViewModel.self)!
            c.viewModel = viewModel
        }
    }
}
