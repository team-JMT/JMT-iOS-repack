//
//  SearchPageViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/01/30.
//

import UIKit
import Swinject
import SwinjectStoryboard


protocol SearchPageViewControllerDelegate {
    func updateSegmentIndex(index: Int)
}

class SearchPageViewController: UIPageViewController {
    
    var searchPVDelegate: SearchPageViewControllerDelegate?
    var vcArray: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        dataSource = self
        
        if let firstVC = vcArray.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension SearchPageViewController: UIPageViewControllerDelegate {
    
}

extension SearchPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard completed else { return }
        
        switch pageViewController.viewControllers?.first {
        case is TotalResultViewController:
            searchPVDelegate?.updateSegmentIndex(index: 0)
        case is RestaurantResultViewController:
            searchPVDelegate?.updateSegmentIndex(index: 1)
        case is GroupResultViewController:
            searchPVDelegate?.updateSegmentIndex(index: 2)
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
