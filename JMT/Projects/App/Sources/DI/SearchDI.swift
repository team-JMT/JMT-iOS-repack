//
//  SearchDI.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import Swinject
import SwinjectStoryboard

struct SearchDI: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(SearchViewModel.self) { r in
            let viewModel = SearchViewModel()
            return viewModel
        }
        
        container.storyboardInitCompleted(SearchViewController.self) { r, c in
            let viewModel = r.resolve(SearchViewModel.self)!
            c.viewModel = viewModel
        }
    }
}

struct TotalResultDI: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(TotalResultViewModel.self) { r in
            let viewModel = TotalResultViewModel()
            return viewModel
        }
        
        container.storyboardInitCompleted(TotalResultViewController.self) { r, c in
            let viewModel = r.resolve(TotalResultViewModel.self)!
            c.viewModel = viewModel
        }
    }
}

struct RestaurantResultDI: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(RestaurantResultViewModel.self) { r in
            let viewModel = RestaurantResultViewModel()
            return viewModel
        }
        
        container.storyboardInitCompleted(RestaurantResultViewController.self) { r, c in
            let viewModel = r.resolve(RestaurantResultViewModel.self)!
            c.viewModel = viewModel
        }
    }
}

struct GroupResultDI: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(GroupResultViewModel.self) { r in
            let viewModel = GroupResultViewModel()
            return viewModel
        }
        
        container.storyboardInitCompleted(GroupResultViewController.self) { r, c in
            let viewModel = r.resolve(GroupResultViewModel.self)!
            c.viewModel = viewModel
        }
    }
}


