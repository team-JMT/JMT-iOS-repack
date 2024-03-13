//
//  GroupCoordinator.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit

protocol GroupCoordinator: Coordinator {
    
}

class DefaultGroupCoordinator: GroupCoordinator {
    var parentCoordinator: Coordinator? = nil
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .home
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    
    func start() {
        let groupViewController = GroupViewController.instantiateFromStoryboard(storyboardName: "Group")
        self.navigationController?.pushViewController(groupViewController, animated: true)
        
    }
    
    
}
