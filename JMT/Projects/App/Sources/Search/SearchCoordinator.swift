//
//  SearchCoordinator.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit

protocol SearchCoordinator: Coordinator {
    
}

class DefaultSearchCoordinator: SearchCoordinator {
    var parentCoordinator: Coordinator? = nil
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .home
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchViewController = SearchViewController.instantiateFromStoryboard(storyboardName: "Search")
        self.navigationController?.pushViewController(searchViewController, animated: true)
        
    }
}
