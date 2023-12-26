//
//  ProfileImageDI.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import Swinject
import SwinjectStoryboard

struct ProfileImageDI: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(ProfileImageViewModel.self) { r in
            let viewModel = ProfileImageViewModel()
            return viewModel
        }
        
        container.storyboardInitCompleted(ProfileImageViewController.self) { r, c in
            let viewModel = r.resolve(ProfileImageViewModel.self)!
            c.viewModel = viewModel
        }
    }
}
