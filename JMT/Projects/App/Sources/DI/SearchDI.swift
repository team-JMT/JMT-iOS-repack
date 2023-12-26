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

