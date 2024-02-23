//
//  MyPageServiceTermsVC.swift
//  JMTeng
//
//  Created by 이지훈 on 2/22/24.
//

import Foundation

import UIKit

protocol MyPageServiceTermsVC: Coordinator {

    
}

class DefaultMyPageServiceTermsVC: MyPageTestCoordinator {
   
    var parentCoordinator: Coordinator? = nil
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .home
    
    init(navigationController: UINavigationController?) {
    
        self.navigationController = navigationController
    }
    
    func start() {
        let mypageViewController = ServiceTermsViewController.instantiateFromStoryboard(storyboardName: "Service") as MyPageTestViewController
        
        mypageViewController.viewModel?.coordinator = self
        self.navigationController?.pushViewController(mypageViewController, animated: true)
        
        
    }
    
    
    
    
}
