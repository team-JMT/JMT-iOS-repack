//
//  RegistrationRestaurantDI.swift
//  JMTeng
//
//  Created by PKW on 2024/02/04.
//

import Swinject
import SwinjectStoryboard

struct RegistrationRestaurantDI: Assembly {
    func assemble(container: Swinject.Container) {
        
        // info
        container.register(RegistrationRestaurantInfoViewModel.self) { r in
            let viewModel = RegistrationRestaurantInfoViewModel()
            return viewModel
        }
        
        container.storyboardInitCompleted(RegistrationRestaurantInfoViewController.self) { r, c in
            let viewModel = r.resolve(RegistrationRestaurantInfoViewModel.self)!
            c.viewModel = viewModel
        }
        
        // map
        container.register(SearchRestaurantMapViewModel.self) { r in
            let viewModel = SearchRestaurantMapViewModel()
            return viewModel
        }
        
        container.storyboardInitCompleted(SearchRestaurantMapViewController.self) { r, c in
            let viewModel = r.resolve(SearchRestaurantMapViewModel.self)!
            c.viewModel = viewModel
        }
        
        // search
        container.register(SearchRestaurantViewModel.self) { r in
            let viewModel = SearchRestaurantViewModel()
            return viewModel
        }
        
        container.storyboardInitCompleted(SearchRestaurantViewController.self) { r, c in
            let viewModel = r.resolve(SearchRestaurantViewModel.self)!
            c.viewModel = viewModel
        }
    }
}
