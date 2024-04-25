//
//  GroupDI.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import Swinject
import SwinjectStoryboard

struct GroupDI: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(GroupViewModel.self) { r in
            let viewModel = GroupViewModel()
            return viewModel
        }
        
        container.storyboardInitCompleted(GroupWebViewController.self) { r, c in
            let viewModel = r.resolve(GroupViewModel.self)!
            c.viewModel = viewModel
        }
    }
}
