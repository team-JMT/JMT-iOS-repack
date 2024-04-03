//
//  NicknameDI.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import Swinject
import SwinjectStoryboard

struct NicknameDI: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(NicknameViewModel.self) { r in
            let viewModel = NicknameViewModel()
            return viewModel
        }
        
        container.storyboardInitCompleted(NicknameViewController.self) { r, c in
            let viewModel = r.resolve(NicknameViewModel.self)!
            c.viewModel = viewModel
        }
    }
}
