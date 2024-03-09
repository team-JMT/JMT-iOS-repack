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
        
        let infoViewController = RestaurantDetailInfoViewController.instantiateFromStoryboard(storyboardName: "RestaurantDetail") as RestaurantDetailInfoViewController
        let photoViewController = RestaurantDetailPhotoViewController.instantiateFromStoryboard(storyboardName: "RestaurantDetail") as RestaurantDetailPhotoViewController
        let reviewViewController = RestaurantDetailReviewViewController.instantiateFromStoryboard(storyboardName: "RestaurantDetail") as RestaurantDetailReviewViewController
        
        restaurantDetailViewController.viewModel?.restauranId = id
        infoViewController.viewModel?.coordinator = self
        photoViewController.viewModel?.coordinator = self
        reviewViewController.viewModel?.coordinator = self
        
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
