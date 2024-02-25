//
//  MyPageServiceTermsVC.swift
//  JMTeng
//
//  Created by 이지훈 on 2/22/24.
//

import Foundation

import UIKit

protocol MyPageServiceTermsCoordinator: Coordinator {

    
}

class DefaultMyPageServiceTermsVC: MyPageServiceTermsCoordinator {
   
    var parentCoordinator: Coordinator? = nil
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .home
    
    init(navigationController: UINavigationController?) {
    
        self.navigationController = navigationController
    }
    
    func start() {
        let mypageViewController = ServiceTermsVC.instantiateFromStoryboard(storyboardName: "ServiceTerm") as ServiceTermsVC
        
        mypageViewController.viewModel.coordinator = self
        self.navigationController?.pushViewController(mypageViewController, animated: true)
        
        
    }
    
    
    
    
}
