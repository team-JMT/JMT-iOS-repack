//
//  RegistrationRestaurantInfoCoordinator.swift
//  JMTeng
//
//  Created by PKW on 2024/02/04.
//

import Foundation
import UIKit

protocol RegistrationRestaurantInfoCoordinator: Coordinator {
    func setRegistrationRestaurantTypeBottomSheetCoordinator()
    func showRegistrationRestaurantTypeBottomSheetViewController()
    
    func showImagePicker()
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
    
    func setRegistrationRestaurantTypeBottomSheetCoordinator() {
        let coordinator = DefaultRegistrationRestaurantTypeBottomSheetCoordinator(navigationController: navigationController, parentCoordinator: self, finishDelegate: self)
        childCoordinators.append(coordinator)
    }
    
    func showRegistrationRestaurantTypeBottomSheetViewController() {
        if getChildCoordinator(.searchRestaurantMenuBS) == nil {
            setRegistrationRestaurantTypeBottomSheetCoordinator()
        }
        
        let coordinator = getChildCoordinator(.searchRestaurantMenuBS) as! RegistrationRestaurantTypeBottomSheetCoordinator
        coordinator.start()
    }
    
    func showImagePicker() {
        
        var config = PhotoKitConfiguration()
        config.library.defaultMultipleSelection = true
        config.library.numberOfItemsInRow = 3
        config.library.maxNumberOfItems = 10
        
        let picker = PhotoKitNavigationController(configuration: config)
        picker.selectedPhotos = handleSelectedPhotos()
        
        picker.didFinishCompletion = { images in
        
            self.handleImagePickerResult(images, isDefault: false)
            picker.dismiss(animated: true)
        }

        self.navigationController?.present(picker, animated: true)
    }
    
    func handleImagePickerResult(_ images: [PhotoInfo], isDefault: Bool) {
        if let registrationRestaurantInfoViewController = self.navigationController?.topViewController as? RegistrationRestaurantInfoViewController {
            registrationRestaurantInfoViewController.viewModel?.updateSelectedImages(images: images)
            registrationRestaurantInfoViewController.updateSection(section: 0)
        }
    }
    
    func handleSelectedPhotos() -> [PhotoInfo] {
        if let registrationRestaurantInfoViewController = self.navigationController?.topViewController as? RegistrationRestaurantInfoViewController {
            return registrationRestaurantInfoViewController.viewModel?.selectedImages ?? []
        }
        return []
    }
    
    func getChildCoordinator(_ type: CoordinatorType) -> Coordinator? {
        var childCoordinator: Coordinator? = nil
        
        switch type {
        case .searchRestaurantMenuBS:
            childCoordinator = childCoordinators.first(where: { $0 is RegistrationRestaurantTypeBottomSheetCoordinator })
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
