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
        if let mypageViewController = storyboard.instantiateViewController(withIdentifier: "DetailMyPageVC") as? DetailMyPageVC {
            let viewModel = DetailMyPageViewModel()
            viewModel.coordinator = self
            mypageViewController.viewModel = viewModel
            navigationController?.pushViewController(mypageViewController, animated: true)
        }
    }

    
    
    func goToServiceTermsViewController() {
        let storyboard = UIStoryboard(name: "Service", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "ServiceTermsViewController") as? ServiceTermsViewController {
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            // viewController가 nil인 경우 로그 출력 또는 디버깅
            print("ServiceTermsViewController could not be instantiated.")
        }
    }

        func goToServiceUseViewController() {
            let storyboard = UIStoryboard(name: "Service", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "ServiceUseViewController") as? ServiceUseViewController {
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
}
