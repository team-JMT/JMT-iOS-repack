//
//  SocialLoginDI.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import Swinject
import SwinjectStoryboard

struct SocialLoginDI: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(SocialLoginViewModel.self) { r in
            let viewModel = SocialLoginViewModel()
            return viewModel
        }
        
        container.storyboardInitCompleted(SocialLoginViewController.self) { r, c in
            let viewModel = r.resolve(SocialLoginViewModel.self)!
            c.viewModel = viewModel
        }
    }
}
