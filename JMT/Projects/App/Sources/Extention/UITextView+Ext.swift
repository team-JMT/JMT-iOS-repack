//
//  UITextView+Ext.swift
//  JMTeng
//
//  Created by PKW on 2024/02/19.
//

import Foundation
import UIKit

extension UITextView {
    
    var numberOfLines: Int {
        // 텍스트 뷰의 너비와 폰트를 기반으로 텍스트의 높이를 계산합니다.
        let textSize = CGSize(width: frame.width, height: CGFloat.infinity)
        let estimatedSize = sizeThatFits(textSize)
        
        // 한 줄의 높이를 계산합니다.
        guard let lineHeight = self.font?.lineHeight else { return 0 }
        
        // 전체 높이를 한 줄의 높이로 나누어 라인 수를 계산합니다.
        return Int(estimatedSize.height / lineHeight)
    }
    
    func alignTextVerticallyInContainer() {
        let textViewSize = self.bounds.size
        let contentSize = self.sizeThatFits(CGSize(width: textViewSize.width, height: CGFloat.greatestFiniteMagnitude))
        
        var offset = (textViewSize.height - contentSize.height) / 2
        offset = max(0, offset)
        self.contentInset = UIEdgeInsets(top: offset, left: 0, bottom: 0, right: 0)
    }
    
    func centerVertically() {
        let fittingSize = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = self.sizeThatFits(fittingSize)
        let topOffset = (self.bounds.size.height - size.height * self.zoomScale) / 2.0
        let positiveTopOffset = max(1, topOffset)
        self.contentOffset = CGPoint(x: 0, y: -positiveTopOffset)
    }
}
