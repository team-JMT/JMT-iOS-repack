//
//  MyPageTestVoordinator.swift
//  App
//
//  Created by 이지훈 on 1/19/24.
//

import Foundation
import UIKit

protocol DetailMyPageCoordinator: Coordinator {
    
    func goToServiceTermsViewController()
    func goToServiceUseViewController()
    
}

class DefaultDetailMyPageCoordinator: DetailMyPageCoordinator {
    
    var parentCoordinator: Coordinator? = nil
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .home
    
    init(navigationController: UINavigationController?) {
        
        self.navigationController = navigationController
    }
    
    
    
    func start() {
        let storyboard = UIStoryboard(name: "DetailMyPage", bundle: nil)
        guard let mypageViewController = storyboard.instantiateViewController(withIdentifier: "DetailMyPageVC") as? DetailMyPageVC else {
            print("DetailMyPageVC could not be instantiated.")
            return
        }
        
        let viewModel = DetailMyPageViewModel()
        viewModel.coordinator = self // Coordinator 할당
        mypageViewController.viewModel = viewModel
        
        // NavigationController 상태 확인
        guard let navigationController = navigationController else {
            print("NavigationController is nil")
            return
        }
        
        navigationController.pushViewController(mypageViewController, animated: true)
    }

    
    
    func goToServiceTermsViewController() {
        let storyboard = UIStoryboard(name: "DetailMyPage", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailMyPageVC") as? DetailMyPageVC {
            let viewModel = DetailMyPageViewModel()
            viewModel.coordinator = self // Assuming 'self' is the coordinator
            detailVC.viewModel = viewModel
            detailVC.coordinator = self // Direct assignment to the VC
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    
    func goToServiceUseViewController() {
        let storyboard = UIStoryboard(name: "Service", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "ServiceUseViewController") as? ServiceUseViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
