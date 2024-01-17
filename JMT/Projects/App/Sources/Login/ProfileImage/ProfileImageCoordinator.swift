//
//  ProfileImageCoordinator.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit

protocol ProfileImageCoordinator: Coordinator {
    func showTabBarViewController()
    func showImagePicker()
    
    func setProfilePopupCoordinator()
    func showProfilePopupViewController()
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
    
    func showImagePicker() {
        
        var config = PhotoKitConfiguration()
        config.library.defaultMultipleSelection = false
        config.library.numberOfItemsInRow = 3
        
        let picker = PhotoKitNavigationController(configuration: config)
        
        picker.didFinishCompletion = { image in
        
            self.handleImagePickerResult(image, isDefault: false)
            picker.dismiss(animated: true)
        }

        self.navigationController?.present(picker, animated: true)
    }
    
    func handleImagePickerResult(_ image: UIImage?, isDefault: Bool) {
        if let profileImageViewController = self.navigationController?.topViewController as? ProfileImageViewController {
            profileImageViewController.profileImageView.image = image
            profileImageViewController.viewModel?.isDefaultProfileImage = isDefault
        }
    }
    
    func setProfilePopupCoordinator() {
        let coordinator = DefaultProfileImagePopupCoordinator(navigationController: navigationController, parentCoordinator: self, finishDelegate: self)
        
        childCoordinators.append(coordinator)
    }
    
    func showProfilePopupViewController() {
        if getChildCoordinator(.profilePop) == nil {
            setProfilePopupCoordinator()
        }
        
        let coordinator = getChildCoordinator(.profilePop) as! ProfileImagePopupCoordinator
        coordinator.start()
    }
    
    func getChildCoordinator(_ type: CoordinatorType) -> Coordinator? {
        var childCoordinator: Coordinator? = nil
        
        switch type {
        case .profilePop:
            childCoordinator = childCoordinators.first(where: { $0 is ProfileImagePopupCoordinator })
        default:
            break
        }
    
        return childCoordinator
    }
}

extension DefaultProfileImageCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter{ $0.type != childCoordinator.type }
    }
}
