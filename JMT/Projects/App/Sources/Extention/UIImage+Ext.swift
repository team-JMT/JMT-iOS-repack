//
//  UIImage+Ext.swift
//  JMTeng
//
//  Created by PKW on 3/10/24.
//

import Foundation
import UIKit

extension UIImage {
    func resizeImage(widthSize: CGFloat) -> UIImage? {
        let targetWidth: CGFloat = widthSize
        let size = self.size

        let widthRatio = targetWidth / size.width
        let newSize = CGSize(width: targetWidth, height: size.height * widthRatio)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
