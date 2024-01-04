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

