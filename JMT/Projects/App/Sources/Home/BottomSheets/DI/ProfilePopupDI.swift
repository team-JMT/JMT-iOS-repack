//
//  ProfilePopupDI.swift
//  JMTeng
//
//  Created by PKW on 2024/01/17.
//

import Foundation
import Swinject
import SwinjectStoryboard

struct ProfilePopupDI: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(ProfileImagePopupViewModel.self) { r in
            let viewModel = ProfileImagePopupViewModel()
            return viewModel
        }
        
        container.storyboardInitCompleted(ProfileImagePopupViewController.self) { r, c in
            let viewModel = r.resolve(ProfileImagePopupViewModel.self)!
            c.viewModel = viewModel
        }
    }
}
