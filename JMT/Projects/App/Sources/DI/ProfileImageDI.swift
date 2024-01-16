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
        
        container.register(DefaultPhotoAuthService.self) { r in
            let authService = DefaultPhotoAuthService()
            return authService
        }
        
        container.storyboardInitCompleted(ProfileImageViewController.self) { r, c in
            let viewModel = r.resolve(ProfileImageViewModel.self)!
            let authService = r.resolve(DefaultPhotoAuthService.self)!
            c.viewModel = viewModel
            c.viewModel?.photoAuthService = authService
        }
    }
}
