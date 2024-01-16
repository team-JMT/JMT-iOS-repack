//
//  NicknameCoordinator.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit

protocol NicknameCoordinator: Coordinator {
    func setProfileCoordinator()
    func showProfileViewController()
}

class DefaultNicknameCoordinator: NicknameCoordinator {
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .socialLogin
    
    init(navigationController: UINavigationController?,
         parentCoordinator: Coordinator,
         finishDelegate: CoordinatorFinishDelegate) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.finishDelegate = finishDelegate
    }
    
    func start() {
        let nicknameViewController = NicknameViewController.instantiateFromStoryboard(storyboardName: "Login") as NicknameViewController
        nicknameViewController.viewModel?.coordinator = self
        self.navigationController?.pushViewController(nicknameViewController, animated: true)
    }

    func setProfileCoordinator() {
        let coordinator = DefaultProfileImageCoordinator(navigationController: navigationController,
                                                         parentCoordinator: self,
                                                         finishDelegate: self)
        
        childCoordinators.append(coordinator)
    }
    
    func showProfileViewController() {
        if getChildCoordinator(.profileImage) == nil {
            setProfileCoordinator()
        }
        let coordinator = getChildCoordinator(.profileImage) as! ProfileImageCoordinator
        coordinator.start()
        
    }
    
    func getChildCoordinator(_ type: CoordinatorType) -> Coordinator? {
        var childCoordinator: Coordinator? = nil
        
        switch type {
        case .profileImage:
            childCoordinator = childCoordinators.first(where: { $0 is ProfileImageCoordinator })
        default:
            break
        }
    
        return childCoordinator
    }
}

extension DefaultNicknameCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter{ $0.type != childCoordinator.type }
    }
}
