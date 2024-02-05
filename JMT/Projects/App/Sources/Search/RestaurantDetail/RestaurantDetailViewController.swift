//
//  RestaurantDetailViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/02/01.
//

import UIKit
import SnapKit


class RestaurantDetailViewController: UIViewController {

    var viewModel: RestaurantDetailViewModel?
    
    var pageViewController: RestaurantDetailPageViewController?
    
    @IBOutlet weak var pageContainerView: UIView!
    
    @IBOutlet weak var restanurantSegController: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pageViewController?.pageViewDelegate = self
        setCustomNavigationBarBackButton(isSearchVC: false)
        
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setupUI() {
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Pretendard-Bold", size: 14),
            .foregroundColor: JMTengAsset.gray300.color // 일반 상태에서의 텍스트 색상
        ]

        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Pretendard-Bold", size: 14),
            .foregroundColor: JMTengAsset.main500.color // 선택된 상태에서의 텍스트 색상
        ]
        
        restanurantSegController.setTitleTextAttributes(normalTextAttributes, for: .normal)
        restanurantSegController.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        if let pageVC = pageViewController {
            self.addChild(pageVC)
            pageContainerView.addSubview(pageVC.view)
            pageVC.didMove(toParent: self)
            
            pageVC.view.snp.makeConstraints { make in
                make.leading.trailing.top.bottom.equalToSuperview()
            }
        }
    }
    
    @IBAction func didTabSegmentedController(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        let direction: UIPageViewController.NavigationDirection = viewModel?.currentSegIndex ?? 0 <= index ? .forward : .reverse

        if let pageVC = pageViewController {
            pageVC.setViewControllers([pageVC.vcArray[index]], direction: direction, animated: true)
            viewModel?.currentSegIndex = index
        }
    }
}

extension RestaurantDetailViewController: RestaurantDetailPageViewControllerDelegate {
    func updateSegmentIndex(index: Int) {
        restanurantSegController.selectedSegmentIndex = index
    }
}
