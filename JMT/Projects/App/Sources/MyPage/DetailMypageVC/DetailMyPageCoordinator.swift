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
    
    func setMyPageManegeCoordinator()
    func showMyPageManageViewController()
    
}

class DefaultDetailMyPageCoordinator: DetailMyPageCoordinator {
    
    var parentCoordinator: Coordinator? = nil
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .detailMyPage
    
    init(navigationController: UINavigationController?) {
        
        self.navigationController = navigationController
    }
    
    
    
    func start() {
        let detailMyPageViewController = DetailMyPageVC.instantiateFromStoryboard(storyboardName: "DetailMyPage") as DetailMyPageVC
        detailMyPageViewController.viewModel?.coordinator = self
        self.navigationController?.pushViewController(detailMyPageViewController, animated: true)
       
    }
    
    func setMyPageManegeCoordinator() {
        let coordinator = DefaultMyPageServiceTermsVC(navigationController: navigationController)
        childCoordinators.append(coordinator)
    }

    func showMyPageManageViewController() {
        //있는지 예외처리
        if getChildCoordinator(.serviceTerms) == nil {
            setMyPageManegeCoordinator()
        }
        
        let coordinator = getChildCoordinator(.serviceTerms) as! MyPageServiceTermsCoordinator
        coordinator.start()
    }
    
    
    func goToServiceTermsViewController() {
        let storyboard = UIStoryboard(name: "DetailMyPage", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailMyPageVC") as? DetailMyPageVC {
            let viewModel = DetailMyPageViewModel()
            viewModel.coordinator = self // Assuming 'self' is the coordinator
            detailVC.viewModel = viewModel
            detailVC.viewModel?.coordinator = self // Direct assignment to the VC
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    
    func goToServiceUseViewController() {
        let storyboard = UIStoryboard(name: "Service", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "ServiceUseViewController") as? ServiceUseViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    //배열내에 있는 코디네이터에 enum으로 선언한 애가 있는지
    func getChildCoordinator(_ type: CoordinatorType) -> Coordinator? {
        var childCoordinator: Coordinator? = nil
        
        switch type {
        case .serviceTerms:
            childCoordinator = childCoordinators.first(where:  { $0 is MyPageServiceTermsCoordinator })
        default:
            break
        }
        
        return childCoordinator
    }
    
    
}

extension DefaultDetailMyPageCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter{ $0.type != childCoordinator.type }
    }
}
