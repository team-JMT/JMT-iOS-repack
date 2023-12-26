//
//  MyPageDI.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import Swinject
import SwinjectStoryboard

struct MyPageDI: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(MyPageViewModel.self) { r in
            let viewModel = MyPageViewModel()
            return viewModel
        }
        
        container.storyboardInitCompleted(MyPageViewController.self) { r, c in
            let viewModel = r.resolve(MyPageViewModel.self)!
            c.viewModel = viewModel
        }
    }
}
