////
////  FirstSegmentCoordinator.swift
////  JMTeng
////
////  Created by 이지훈 on 3/21/24.
////
//
//import Foundation
//import UIKit
//
//protocol FirstSegmentCoordinator {
//    var childCoordinators: [Coordinator] { get set }
//        var navigationController: UINavigationController? { get set }
//}
//
//class DefaultFirstSegmentCoordinator: Coordinator {
//   
//    func goToDetailView(for segmentIndex: Int) {
//        print(1)
//    }
//    
//    func goToDetailMyPageView() {
//        print(1)
//    }
//    
//    func setDetailMyPageCoordinator() {
//        print(1)
//    }
//    
//    func showDetailMyPageVieController() {
//        print(1)
//    }
//    
//    
//    
//    func start() {
//        let mypageViewController = FirstSegmentViewController.instantiateFromStoryboard(storyboardName: "MyPage") as FirstSegmentViewController
//        
//        mypageViewController.viewModel.coordinator = self
//        self.navigationController?.pushViewController(mypageViewController, animated: true)
//        
//        
//    }
//    
//    
//    
//    
//     var parentCoordinator: Coordinator? = nil
//     
//     var childCoordinators: [Coordinator] = []
//     var navigationController: UINavigationController?
//     var finishDelegate: CoordinatorFinishDelegate?
//     var type: CoordinatorType = .home
//     
//     init(navigationController: UINavigationController?) {
//     
//         self.navigationController = navigationController
//     }
//    
//    
//    func start(id: Int) {
//        // 상세 화면으로 전환하는 로직 구현
//        let storyboard = UIStoryboard(name: "Main", bundle: nil) // 상세 화면이 있는 스토리보드 이름 확인
//        if let detailVC = storyboard.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as? RestaurantDetailViewController {
//            detailVC.restaurantID = id // 식당 ID 전달
//            navigationController?.pushViewController(detailVC, animated: true)
//        }
//    }
//}
//
