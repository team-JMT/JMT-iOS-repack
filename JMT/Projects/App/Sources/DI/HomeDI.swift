//
//  HomeDI.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import Swinject
import SwinjectStoryboard

struct HomeDI: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(HomeViewModel.self) { r in
            let viewModel = HomeViewModel()
            return viewModel
        }
        
        container.storyboardInitCompleted(HomeViewController.self) { r, c in
            let viewModel = r.resolve(HomeViewModel.self)!
            c.viewModel = viewModel
        }
    }
}
