//
//  ProfileImageCoordinator.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit

protocol ProfileImageCoordinator: Coordinator {
    func showTabBarViewController()
}

class DefaultProfileImageCoordinator: ProfileImageCoordinator {
    
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
        let profileViewController = ProfileImageViewController.instantiateFromStoryboard(storyboardName: "Login") as ProfileImageViewController
        profileViewController.viewModel?.coordinator = self
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func showTabBarViewController() {
        let appCoordinator = self.getTopCoordinator()
        

        let socialLoginCoordinator = appCoordinator.childCoordinators.first(where: { $0 is SocialLoginCoordinator })
        socialLoginCoordinator?.finish()
    
        appCoordinator.showTabBarViewController()
    }
}

extension DefaultProfileImageCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter{ $0.type != childCoordinator.type }
    }
}
