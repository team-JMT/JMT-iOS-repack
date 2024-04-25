//
//  UIFont+Ext.swift
//  JMT
//
//  Created by PKW on 2023/11/01.
//

import Foundation
import UIKit

// 글자 간격
extension UILabel {
    func setAttributedText(str: String, lineHeightMultiple: CGFloat, kern: CGFloat, alignment: NSTextAlignment) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.alignment = alignment
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .kern: kern
        ]
        
        let attributedString = NSMutableAttributedString(string: str, attributes: attributes)
        self.attributedText = attributedString
    }
}

