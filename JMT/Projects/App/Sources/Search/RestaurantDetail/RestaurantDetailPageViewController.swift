//
//  RestaurantDetailPageViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/02/02.
//

import UIKit

protocol RestaurantDetailPageViewControllerDelegate: AnyObject {
    func updateSegmentIndex(index: Int)
}

class RestaurantDetailPageViewController: UIPageViewController {
    
    weak var pageViewDelegate: RestaurantDetailPageViewControllerDelegate?
    var vcArray: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        
        if let firstVC = vcArray.first {
            setViewControllers([firstVC], direction: .forward, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
}

extension RestaurantDetailPageViewController: UIPageViewControllerDelegate {
    
}

extension RestaurantDetailPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard completed else { return }
        
        switch pageViewController.viewControllers?.first {
        case is RestaurantDetailInfoViewController:
            pageViewDelegate?.updateSegmentIndex(index: 0)
        case is RestaurantDetailPhotoViewController:
            pageViewDelegate?.updateSegmentIndex(index: 1)
        case is RestaurantDetailReviewViewController:
            pageViewDelegate?.updateSegmentIndex(index: 2)
        default:
            print("nil")
        }
    }
    
    // 이전 페이지 이동
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
       
        guard let vcIndex = vcArray.firstIndex(of: viewController) else { return nil }
        
        let prevIndex = vcIndex - 1
        
        guard prevIndex >= 0 else { return nil }
        
        guard vcArray.count > prevIndex else { return nil }
        
        return vcArray[prevIndex]
    }
    
    // 다음 페이지 이동
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = vcArray.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = vcIndex + 1
        
        guard nextIndex < vcArray.count else { return nil }
        
        guard vcArray.count > nextIndex else { return nil }
    
        return vcArray[nextIndex]
    }
}
