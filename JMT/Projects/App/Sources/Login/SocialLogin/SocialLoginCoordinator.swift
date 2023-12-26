//
//  SocialLoginCoordinator.swift
//  App
//
//  Created by PKW on 2023/12/20.
//

import UIKit

protocol SocialLoginCoordinator: Coordinator {
    func setNicknameCoordinator()
    func showNicknameViewController()
}

class DefaultSocialLoginCoordinator: SocialLoginCoordinator {
    
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
        let initialViewController = SocialLoginViewController.instantiateFromStoryboard(storyboardName: "Login") as SocialLoginViewController
        initialViewController.viewModel?.coordinator = self
        self.navigationController?.pushViewController(initialViewController, animated: true)
    }
    
    func setNicknameCoordinator() {
        let coordinator = DefaultNicknameCoordinator(navigationController: navigationController,
                                                     parentCoordinator: self,
                                                     finishDelegate: self)
        childCoordinators.append(coordinator)
    }
    
    func showNicknameViewController() {
        if getChildCoordinator(.nickname) == nil {
            setNicknameCoordinator()
        }
        
        let nicknameCoordinator = getChildCoordinator(.nickname) as! NicknameCoordinator
        nicknameCoordinator.start()
    }
    
    func getChildCoordinator(_ type: CoordinatorType) -> Coordinator? {
        var childCoordinator: Coordinator? = nil
        
        switch type {
        case .nickname:
            childCoordinator = childCoordinators.first(where: { $0 is NicknameCoordinator })
        default:
            break
        }
        return childCoordinator
    }
}

extension DefaultSocialLoginCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter{ $0.type != childCoordinator.type }
    }
}


