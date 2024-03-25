//
//  RestaurantTitle2HeaderView.swift
//  JMTeng
//
//  Created by PKW on 2024/02/01.
//

import UIKit

class RestaurantTitle2HeaderView: UICollectionReusableView {

    @IBOutlet weak var differentGroupHeaderTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLabel()
    }
    
    func setupLabel() {
        // 레이블 텍스트 설정
        differentGroupHeaderTitleLabel.setAttributedText(str: "원하는 맛집이 없으신가요?\n다른 그룹에서도 둘러보세요", lineHeightMultiple: 1.25, kern: -0.28, alignment: .left)
    }
}
