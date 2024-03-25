//
//  UIView+Ext.swift
//  JMTeng
//
//  Created by PKW on 2024/02/28.
//

import Foundation
import UIKit
import Then

extension UIView {
    func addShadow(
        color: UIColor = JMTengAsset.gray200.color,
        opacity: Float = 1,
        offset: CGSize = CGSize(width: 0, height: 0),
        radius: CGFloat = 5,
        masksToBounds: Bool = false
    ) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.masksToBounds = masksToBounds
    }
}
