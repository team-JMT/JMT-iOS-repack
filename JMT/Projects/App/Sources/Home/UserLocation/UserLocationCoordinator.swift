//
//  UserLocationCoordinator.swift
//  JMTeng
//
//  Created by PKW on 2024/01/19.
//

import Foundation
import UIKit

protocol UserLocationCoordinator: Coordinator {
    var enterPoint: Int { get set }
    func setButtonPopupCoordinator()
    func showButtonPopupViewController()
}

class DefaultUserLocationCoordinator: UserLocationCoordinator {

    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .userLocation
    
    var enterPoint: Int = 0
    
    init(navigationController: UINavigationController?, parentCoordinator: Coordinator,
         finishDelegate: CoordinatorFinishDelegate) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.finishDelegate = finishDelegate
    }
    
    func start() {
        let userLocationViewController = UserLocationViewController.instantiateFromStoryboard(storyboardName: "UserLocation") as UserLocationViewController
        userLocationViewController.viewModel?.enterPoint = enterPoint
        userLocationViewController.viewModel?.coordinator = self
        self.navigationController?.pushViewController(userLocationViewController, animated: true)
    }
    
    func setButtonPopupCoordinator() {
        let coordinator = DefaultButtonPopupCoordinator(navigationController: navigationController, parentCoordinator: self, finishDelegate: self)
        childCoordinators.append(coordinator)
    }
    
    func showButtonPopupViewController() {
        if getChildCoordinator(.buttonPopup) == nil {
            setButtonPopupCoordinator()
        }
        
        let coordinator = getChildCoordinator(.buttonPopup) as! ButtonPopupCoordinator
        coordinator.start()
    }
    
    func getChildCoordinator(_ type: CoordinatorType) -> Coordinator? {
        var childCoordinator: Coordinator? = nil
        
        switch type {
        case .buttonPopup:
            childCoordinator = childCoordinators.first(where: { $0 is ButtonPopupCoordinator })
        default:
            break
        }
    
        return childCoordinator
    }
    
}

extension DefaultUserLocationCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter{ $0.type != childCoordinator.type }
    }
}
