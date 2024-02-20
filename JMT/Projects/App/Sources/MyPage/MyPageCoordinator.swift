//
//  MyPageCoordinator.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit

protocol MyPageCoordinator: Coordinator {
   
    func goToDetailView(for segmentIndex: Int)
    func goToDetailMyPageView()
    //func goToTestt()
    
}

class DefaultMyPageCoordinator: MyPageCoordinator {
    
    var parentCoordinator: Coordinator? = nil
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .home
    
    init(navigationController: UINavigationController?) {
    
        self.navigationController = navigationController
    }
    
    func start() {
        let mypageViewController = MyPageViewController.instantiateFromStoryboard(storyboardName: "MyPage") as MyPageViewController
        
         mypageViewController.coordinator = self
        self.navigationController?.pushViewController(mypageViewController, animated: true)
    }
    
    
    func goToDetailView(for segmentIndex: Int) {
     //   goToSegmentViewController(for : segmentIndex)
    }
    
    
    func goToDetailMyPageView() {
        let storyboard = UIStoryboard(name: "DetailMyPage", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "DetailMyPageVC") as? DetailMyPageVC {
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            print("DetailMyPageVC could not be instantiated.")
        }
    }


    
}
