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
        
         mypageViewController.coordinator = self
        self.navigationController?.pushViewController(mypageViewController, animated: true)
        
        
    }
    
    
    func goToDetailView(for segmentIndex: Int) {
     //   goToSegmentViewController(for : segmentIndex)
    }

//    func goToSegmentViewController(for index: Int) {
//           switch index {
//           case 0:
//               showFirstSegmentViewController()
//           case 1:
//               showSecondSegmentViewController()
//           case 2:
//               showThirdSegmentViewController()
//           default:
//               break
//           }
//       }
////
//       private func showFirstSegmentViewController() {
//           // 첫 번째 세그먼트에 해당하는 뷰 컨트롤러 생성 및 표시
//           let viewController = FirstSegmentViewController.instantiateFromStoryboard(storyboardName: "MyPage")
//           navigationController?.pushViewController(viewController, animated: true)
//       }
//
//       private func showSecondSegmentViewController() {
//           // 두 번째 세그먼트에 해당하는 뷰 컨트롤러 생성 및 표시
//           let viewController = SecondSegmentViewController.instantiateFromStoryboard(storyboardName: "MyPage")
//           navigationController?.pushViewController(viewController, animated: true)
//       }
//
//       private func showThirdSegmentViewController() {
//           // 세 번째 세그먼트에 해당하는 뷰 컨트롤러 생성 및 표시
//           let viewController = ThirdSegmentViewController.instantiateFromStoryboard(storyboardName: "MyPage")
//           navigationController?.pushViewController(viewController, animated: true)
//       }
}
