//
//  MyPageCoordinator.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit

protocol MyPageCoordinator: Coordinator {
    func goToDetailView(for segmentIndex: Int)

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
        
         mypageViewController.viewModel?.coordinator = self
        self.navigationController?.pushViewController(mypageViewController, animated: true)
        
        
    }

    // 세그먼트 인덱스에 따라 다른 뷰 컨트롤러를 푸시.
    func goToDetailView(for segmentIndex: Int) {
            switch segmentIndex {
            case 0:
                print("1111")
            case 1:
                print("12123")
            case 2:
                print("13124321")
            default: 
                break
            }
        }
}
