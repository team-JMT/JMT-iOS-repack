//
//  UIView+Ext.swift
//  JMTeng
//
//  Created by PKW on 2024/02/08.
//

import Foundation
import UIKit

extension UICollectionView {
    func moveToScroll(section: Int, row: Int, margin: CGFloat) {
        let indexPath = IndexPath(row: row, section: section)
        
        guard let layoutAttributes = self.layoutAttributesForItem(at: indexPath) else { return }
        
        let topMargin: CGFloat = margin
        
        var targetY = layoutAttributes.frame.origin.y - self.contentInset.top - topMargin
        
        let maxScrollableY = self.contentSize.height - self.bounds.height + self.contentInset.bottom
        
        targetY = min(targetY, maxScrollableY)
        
        self.setContentOffset(CGPoint(x: 0, y: targetY), animated: true)
    }
}
