//
//  HomeCoordinator.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit

protocol HomeCoordinator: Coordinator {
    
}

class DefaultHomeCoordinator: HomeCoordinator {
    var parentCoordinator: Coordinator? = nil
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .home
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeViewController = HomeViewController.instantiateFromStoryboard(storyboardName: "Home") as HomeViewController
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
}
