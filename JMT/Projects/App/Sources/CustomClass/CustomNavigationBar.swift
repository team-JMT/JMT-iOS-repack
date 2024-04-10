//
//  CustomNavigationBar.swift
//  JMTeng
//
//  Created by PKW on 4/8/24.
//

import UIKit

class CustomNavigationBar: UINavigationBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNavigationBarStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNavigationBarStyle()
    }
    
    private func setupNavigationBarStyle() {
        // 그림자 이미지 설정 (그림자 제거)
        self.shadowImage = UIImage()
        // 배경 이미지 설정 (투명 이미지로 설정하여 배경 제거 혹은 커스텀 이미지 적용)
        self.setBackgroundImage(UIImage(), for: .default)
    }
    
    func setupTitle(title: String) {
        self.topItem?.title = title
    }
}
