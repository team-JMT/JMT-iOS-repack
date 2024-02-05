//
//  RegistrationRestaurantInfoCoordinator.swift
//  JMTeng
//
//  Created by PKW on 2024/02/04.
//

import Foundation
import UIKit

protocol RegistrationRestaurantInfoCoordinator: Coordinator {
    func setRegistrationRestaurantMenuBottomSheetCoordinator()
    func showRegistrationRestaurantMenuBottomSheetViewController()
}

class DefaultRegistrationRestaurantInfoCoordinator: RegistrationRestaurantInfoCoordinator {
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .registrationRestaurantInfo
    
    init(navigationController: UINavigationController?,
         parentCoordinator: Coordinator?,
         finishDelegate: CoordinatorFinishDelegate?) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.finishDelegate = finishDelegate
    }
    
    func start() {
        let registrationRestaurantInfoViewController = RegistrationRestaurantInfoViewController.instantiateFromStoryboard(storyboardName: "RegistrationRestaurantInfo") as RegistrationRestaurantInfoViewController
        registrationRestaurantInfoViewController.viewModel?.coordinator = self
        self.navigationController?.pushViewController(registrationRestaurantInfoViewController, animated: true)
    }
    
    func setRegistrationRestaurantMenuBottomSheetCoordinator() {
        let coordinator = DefaultRegistrationRestaurantMenuBottomSheetCoordinator(navigationController: navigationController, parentCoordinator: self, finishDelegate: self)
        childCoordinators.append(coordinator)
    }
    
    func showRegistrationRestaurantMenuBottomSheetViewController() {
        if getChildCoordinator(.searchRestaurantMenuBS) == nil {
            setRegistrationRestaurantMenuBottomSheetCoordinator()
        }
        
        let coordinator = getChildCoordinator(.searchRestaurantMenuBS) as! RegistrationRestaurantMenuBottomSheetCoordinator
        coordinator.start()
    }
    
    func getChildCoordinator(_ type: CoordinatorType) -> Coordinator? {
        var childCoordinator: Coordinator? = nil
        
        switch type {
        case .searchRestaurantMenuBS:
            childCoordinator = childCoordinators.first(where: { $0 is RegistrationRestaurantMenuBottomSheetCoordinator })
        default:
            break
        }
        return childCoordinator
    }
}

extension DefaultRegistrationRestaurantInfoCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter{ $0.type != childCoordinator.type }
    }
}
