//
//  RegistrationRestaurantInfoCoordinator.swift
//  JMTeng
//
//  Created by PKW on 2024/02/04.
//

import Foundation
import UIKit

protocol RegistrationRestaurantInfoCoordinator: Coordinator {
    func start(info: SearchRestaurantsLocationModel?)
    
    func setButtonPopupCoordinator()
    func showButtonPopupViewController()
    
    func showImagePicker()
    
    func setDetailRestaurantCoordinator()
    func showDetailRestaurantViewController(id: Int)
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
    
    func start(info: SearchRestaurantsLocationModel?) {
        let registrationRestaurantInfoViewController = RegistrationRestaurantInfoViewController.instantiateFromStoryboard(storyboardName: "RegistrationRestaurantInfo") as RegistrationRestaurantInfoViewController
        registrationRestaurantInfoViewController.viewModel?.coordinator = self
        registrationRestaurantInfoViewController.viewModel?.info = info
        self.navigationController?.pushViewController(registrationRestaurantInfoViewController, animated: true)
    }
    
    func showImagePicker() {
        
        let photoService = DefaultPhotoAuthService()
        
        var config = PhotoKitConfiguration()
        config.library.defaultMultipleSelection = true
        config.library.numberOfItemsInRow = 3
        config.library.maxNumberOfItems = 10
        
        let picker = PhotoKitNavigationController(configuration: config)
        picker.photosCount = handleSelectedPhotosCount()
        
        picker.didFinishCompletion = { [weak self] images in
        
            self?.handleImagePickerResult(images, isDefault: false)
            picker.dismiss(animated: true)
        }
        
        photoService.requestAuthorization { [weak self] result in
            switch result {
            case .success(let _):
                self?.navigationController?.present(picker, animated: true)
            case .failure(let _):
                if let topViewController = self?.navigationController?.topViewController {
                    topViewController.showAccessDeniedAlert(type: .photo)
                }
            }
        }
    }
    
    func handleImagePickerResult(_ images: [UIImage], isDefault: Bool) {
        if let registrationRestaurantInfoViewController = self.navigationController?.topViewController as? RegistrationRestaurantInfoViewController {
            registrationRestaurantInfoViewController.viewModel?.updateSelectedImages(images: images)
            registrationRestaurantInfoViewController.updateSection(section: 0)
        }
    }
    
    func handleSelectedPhotosCount() -> Int {
        if let registrationRestaurantInfoViewController = self.navigationController?.topViewController as? RegistrationRestaurantInfoViewController {
            return registrationRestaurantInfoViewController.viewModel?.selectedImages.count ?? 0
        }
        return 0
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
    
    func setDetailRestaurantCoordinator() {
        let coordinator = DefaultRestaurantDetailCoordinator(navigationController: navigationController, parentCoordinator: self, finishDelegate: self)
        childCoordinators.append(coordinator)
    }
    
    func showDetailRestaurantViewController(id: Int) {
        if getChildCoordinator(.restaurantDetail) == nil {
            setDetailRestaurantCoordinator()
        }
        
        let coordinator = getChildCoordinator(.restaurantDetail) as! DefaultRestaurantDetailCoordinator
        coordinator.start(id: id)
    }
    
    func getChildCoordinator(_ type: CoordinatorType) -> Coordinator? {
        var childCoordinator: Coordinator? = nil
        
        switch type {
        case .buttonPopup:
            childCoordinator = childCoordinators.first(where: { $0 is ButtonPopupCoordinator })
        case .restaurantDetail:
            childCoordinator = childCoordinators.first(where: { $0 is RestaurantDetailCoordinator })
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
