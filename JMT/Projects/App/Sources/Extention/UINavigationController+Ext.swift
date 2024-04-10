//
//  UINavigationController+Ext.swift
//  JMTeng
//
//  Created by PKW on 3/12/24.
//

import Foundation
import UIKit

extension UINavigationController: UIGestureRecognizerDelegate {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
    
    func setupBarAppearance(alpha: CGFloat) {
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithDefaultBackground()
//        appearance.backgroundColor = .white
//        
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.black.withAlphaComponent(alpha)] // 타이틀 텍스트 속성 설정
//        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black.withAlphaComponent(alpha)] // 큰 타이틀 텍스트 속성 설정
//        appearance.shadowColor = nil
//        
//        navigationBar.standardAppearance = appearance
//        navigationBar.compactAppearance = appearance
//        navigationBar.scrollEdgeAppearance = appearance
    }
}
