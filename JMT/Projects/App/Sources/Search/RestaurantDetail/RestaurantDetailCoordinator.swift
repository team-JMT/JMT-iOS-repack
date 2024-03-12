//
//  RestaurantDetailCoordinator.swift
//  JMTeng
//
//  Created by PKW on 2024/02/01.
//

import Foundation
import UIKit

protocol RestaurantDetailCoordinator: Coordinator {
    func showImagePicker()
    func start(id: Int)
}
class DefaultRestaurantDetailCoordinator: RestaurantDetailCoordinator {
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .restaurantDetail
    
    init(navigationController: UINavigationController?,
         parentCoordinator: Coordinator, finishDelegate: CoordinatorFinishDelegate) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.finishDelegate = finishDelegate
    }
    
    func start() { }
    func start(id: Int) {
        let restaurantDetailViewController = RestaurantDetailViewController.instantiateFromStoryboard(storyboardName: "RestaurantDetail") as RestaurantDetailViewController
        restaurantDetailViewController.viewModel?.coordinator = self
        
        guard let pageViewController = UIStoryboard(name: "RestaurantDetail", bundle: nil).instantiateViewController(withIdentifier: "RestaurantDetailPageViewController") as? RestaurantDetailPageViewController else { return }
        
        guard let infoViewController = UIStoryboard(name: "RestaurantDetail", bundle: nil).instantiateViewController(withIdentifier: "RestaurantDetailInfoViewController") as? RestaurantDetailInfoViewController else { return }
        
        guard let photoViewController = UIStoryboard(name: "RestaurantDetail", bundle: nil).instantiateViewController(withIdentifier: "RestaurantDetailPhotoViewController") as? RestaurantDetailPhotoViewController else { return }
        
        guard let reviewViewController = UIStoryboard(name: "RestaurantDetail", bundle: nil).instantiateViewController(withIdentifier: "RestaurantDetailReviewViewController") as? RestaurantDetailReviewViewController else { return }
        
        restaurantDetailViewController.viewModel?.recommendRestaurantId = id
        
        infoViewController.viewModel = restaurantDetailViewController.viewModel
        photoViewController.viewModel = restaurantDetailViewController.viewModel
        reviewViewController.viewModel = restaurantDetailViewController.viewModel
        
        pageViewController.vcArray = [infoViewController, photoViewController, reviewViewController]
        
        restaurantDetailViewController.pageViewController = pageViewController
                
        self.navigationController?.pushViewController(restaurantDetailViewController, animated: true)
    }
    
    func showImagePicker() {
        
        let photoservice = DefaultPhotoAuthService()
        
        var config = PhotoKitConfiguration()
        config.library.defaultMultipleSelection = true
        config.library.maxNumberOfItems = 5
    
        let picker = PhotoKitNavigationController(configuration: config)
        picker.photosCount = handleSelectedPhotosCount()
        
        picker.didFinishCompletion = { images in
        
            self.handleImagePickerResult(images, isDefault: false)
            picker.dismiss(animated: true)
        }
        
        photoservice.requestAuthorization { result in
            switch result {
            case .success(_):
                self.navigationController?.present(picker, animated: true)
            case .failure(_):
                if let topViewController = self.navigationController?.topViewController {
                    topViewController.showAccessDeniedAlert(type: .photo)
                }
            }
        }
    }
    
    func handleImagePickerResult(_ images: [UIImage], isDefault: Bool) {
        if let restaurantDetailViewController = self.navigationController?.topViewController as? RestaurantDetailViewController {
            restaurantDetailViewController.viewModel?.updateReviewImages(images: images)
        }
    }
    
    func handleSelectedPhotosCount() -> Int {
        if let restaurantDetailViewController = self.navigationController?.topViewController as? RestaurantDetailViewController {
            return restaurantDetailViewController.viewModel?.reviewImages.count ?? 0
        }
        return 0
    }
}

extension DefaultRestaurantDetailCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        print("DefaultRestaurantDetailCoordinator Finish")
        self.childCoordinators = self.childCoordinators.filter{ $0.type != childCoordinator.type }
    }
}
