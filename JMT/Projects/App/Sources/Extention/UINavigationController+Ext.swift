//
//  UINavigationController+Ext.swift
//  JMTeng
//
//  Created by PKW on 3/12/24.
//

import Foundation
import UIKit

extension UINavigationController {
    func setupBarAppearance(alpha: CGFloat) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .white
        
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black.withAlphaComponent(alpha)] // 타이틀 텍스트 속성 설정
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black.withAlphaComponent(alpha)] // 큰 타이틀 텍스트 속성 설정
        appearance.shadowColor = nil
        
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        //        navigationBar.isTranslucent = false
        //        navigationBar.tintColor = .red
        //        navigationBar.prefersLargeTitles = true
    }
}
