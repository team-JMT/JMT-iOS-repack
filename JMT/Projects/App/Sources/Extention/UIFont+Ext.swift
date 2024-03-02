//
//  UIFont+Ext.swift
//  JMT
//
//  Created by PKW on 2023/11/01.
//

import Foundation
import UIKit

extension UIFont {
    
    enum CustomFont: String {
        case pretendardBold = "Pretendard-Bold"
        case pretendardExtraBold = "Pretendard-ExtraBold"
        case pretendardMedium = "Pretendard-Medium"
        case pretendardRegular = "Pretendard-Regular"
        case pretendardSemiBold = "Pretendard-SemiBold"
    }
    
    static func settingFont(_ font: CustomFont, size: CGFloat) -> UIFont {
        return UIFont(name: font.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

// 글자 간격
extension UILabel {
    func setAttributedText(str: String, lineHeightMultiple: CGFloat, kern: CGFloat, alignment: NSTextAlignment) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.alignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .kern: kern
        ]
        
        let attributedString = NSMutableAttributedString(string: str, attributes: attributes)
        self.attributedText = attributedString
    }
}

