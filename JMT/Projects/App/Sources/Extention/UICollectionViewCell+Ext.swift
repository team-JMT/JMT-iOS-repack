//
//  UICollectionViewCell+Ext.swift
//  JMTeng
//
//  Created by PKW on 2024/02/08.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    func getCollectionView() -> UICollectionView? {
        
        if let collectionView = self.superview as? UICollectionView {
            return collectionView
        }
        
        return nil
    }
}
