//
//  MyPageTestVoordinator.swift
//  App
//
//  Created by 이지훈 on 1/19/24.
//

import Foundation

import UIKit

protocol MyPageTestCoordinator: Coordinator {

    
}

class DefaultMyPageTestCoordinator: MyPageTestCoordinator, MyPageCoordinator {
    func goToTestt() {
        <#code#>
    }
    
    var parentCoordinator: Coordinator? = nil
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .home
    
    init(navigationController: UINavigationController?) {
    
        self.navigationController = navigationController
    }
    
    func start() {
        let mypageViewController = MyPageTestViewController.instantiateFromStoryboard(storyboardName: "MyPage") as MyPageViewController
        
        mypageViewController.viewModel?.coordinator = self
        self.navigationController?.pushViewController(mypageViewController, animated: true)
        
        
    }
    
    
    
    
}
