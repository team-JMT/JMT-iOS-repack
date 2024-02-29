//
//  Coor.swift
//  JMTeng
//
//  Created by 이지훈 on 2/29/24.
//

import Foundation

import UIKit

protocol MyPageChangeNicknaemCoordinator: Coordinator {

    
}

class DefaultMyPageChangeNicknaemCoordinator: MyPageChangeNicknaemCoordinator {
   
    var parentCoordinator: Coordinator? = nil
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .changeNickname
    
    init(navigationController: UINavigationController?) {
    
        self.navigationController = navigationController
    }
    
    func start() {
        let mypageViewController = ChangeNickNameVC.instantiateFromStoryboard(storyboardName: "changeNickname") as ChangeNickNameVC
        
        mypageViewController.viewModel?.coordinator = self
        self.navigationController?.pushViewController(mypageViewController, animated: true)
        
        
    }
    
    
    
    
}
