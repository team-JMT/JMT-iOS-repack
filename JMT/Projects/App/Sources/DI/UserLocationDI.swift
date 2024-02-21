//
//  UserLocationDI.swift
//  JMTeng
//
//  Created by PKW on 2024/01/19.
//

import Swinject
import SwinjectStoryboard

struct UserLocationDI: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(UserLocationViewModel.self) { r in
            let viewModel = UserLocationViewModel()
            return viewModel
        }
        
        container.storyboardInitCompleted(UserLocationViewController.self) { r, c in
            let viewModel = r.resolve(UserLocationViewModel.self)!
            c.viewModel = viewModel
        }
        
        container.register(ConvertUserLocationViewModel.self) { r in
            let viewModel = ConvertUserLocationViewModel()
            return viewModel
        }
        
        container.storyboardInitCompleted(ConvertUserLocationViewController.self) { r, c in
            let viewModel = r.resolve(ConvertUserLocationViewModel.self)!
            c.viewModel = viewModel
        }
    }
}
