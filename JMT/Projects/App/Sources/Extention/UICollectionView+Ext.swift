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
    
    func setEmptyBackgroundView(str: String) {
        let emptyView = UIView().then {
            $0.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        }
        
        let baseStackView = UIStackView().then {
            $0.axis = .vertical
            $0.distribution = .equalSpacing
            $0.alignment = .center
            $0.spacing = 16
        }
        
        let commentLabel = UILabel().then {
            $0.font = UIFont.settingFont(.pretendardBold, size: 16)
            $0.textColor = JMTengAsset.gray300.color
            $0.numberOfLines = 0

            $0.setAttributedText(str: str, lineHeightMultiple: 1.25, kern: -0.32, alignment: .center)
        }
        
        let emptyImageView = UIImageView(image: JMTengAsset.emptyResult.image).then {
            $0.contentMode = .scaleAspectFit
        }
        
        baseStackView.addArrangedSubview(emptyImageView)
        baseStackView.addArrangedSubview(commentLabel)
        emptyView.addSubview(baseStackView)
        
        baseStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        self.backgroundView = emptyView
    }
    
    func removeEmptyBackgroundView() {
        self.backgroundView = nil
    }
}

