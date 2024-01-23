//
//  HomeCoordinator.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit

protocol HomeCoordinator: Coordinator {
    func setUserLocationCoordinator()
    func showUserLocationViewController(tag: Int)
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
        homeViewController.viewModel?.coordinator = self
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    func setUserLocationCoordinator() {
        let coordinator = DefaultUserLocationCoordinator(navigationController: navigationController,
                                                         parentCoordinator: self,
                                                         finishDelegate: self)
        childCoordinators.append(coordinator)
    }
    
    func showUserLocationViewController(tag: Int) {
        if getChildCoordinator(.userLocation) == nil {
            setUserLocationCoordinator()
        }
        
        let coordinator = getChildCoordinator(.userLocation) as! UserLocationCoordinator
        coordinator.enterPoint = tag
        coordinator.start()
    }
    
    func getChildCoordinator(_ type: CoordinatorType) -> Coordinator? {
        var childCoordinator: Coordinator? = nil
        
        switch type {
        case .userLocation:
            childCoordinator = childCoordinators.first(where: { $0 is UserLocationCoordinator })
        default:
            break
        }
    
        return childCoordinator
    }
    
    
}


extension DefaultHomeCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter{ $0.type != childCoordinator.type }
    }
}
