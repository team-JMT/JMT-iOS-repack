//
//  SearchRestaurantMapCoordinator.swift
//  JMTeng
//
//  Created by PKW on 2024/02/04.
//

import Foundation
import UIKit

protocol SearchRestaurantMapCoordinator: Coordinator {
    func setRegistrationRestaurantInfoCoordinator()
    func showRegistrationRestaurantInfoViewController()
}

class DefaultSearchRestaurantMapCoordinator: SearchRestaurantMapCoordinator {
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .searchRestaurantMap
    
    init(navigationController: UINavigationController?,
         parentCoordinator: Coordinator?,
         finishDelegate: CoordinatorFinishDelegate?) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.finishDelegate = finishDelegate
    }
    
    func start() {
        let searchRestaurantMapViewController = SearchRestaurantMapViewController.instantiateFromStoryboard(storyboardName: "SearchRestaurantMap") as SearchRestaurantMapViewController
        searchRestaurantMapViewController.viewModel?.coordinator = self
        self.navigationController?.pushViewController(searchRestaurantMapViewController, animated: true)
    }
    
    func setRegistrationRestaurantInfoCoordinator() {
        let coordinator = DefaultRegistrationRestaurantInfoCoordinator(navigationController: navigationController, parentCoordinator: self, finishDelegate: self)
        childCoordinators.append(coordinator)
    }
    
    func showRegistrationRestaurantInfoViewController() {
        if getChildCoordinator(.registrationRestaurantInfo) == nil {
            setRegistrationRestaurantInfoCoordinator()
        }
        
        let coordinator = getChildCoordinator(.registrationRestaurantInfo) as! RegistrationRestaurantInfoCoordinator
        coordinator.start()
    }
    
    func getChildCoordinator(_ type: CoordinatorType) -> Coordinator? {
        var childCoordinator: Coordinator? = nil
        
        switch type {
        case .registrationRestaurantInfo:
            childCoordinator = childCoordinators.first(where: { $0 is RegistrationRestaurantInfoCoordinator })
        default:
            break
        }
        return childCoordinator
    }
}

extension DefaultSearchRestaurantMapCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter{ $0.type != childCoordinator.type }
    }
}

