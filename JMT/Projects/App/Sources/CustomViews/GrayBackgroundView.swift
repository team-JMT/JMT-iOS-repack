//
//  GrayBackgroundView.swift
//  JMTeng
//
//  Created by PKW on 2024/01/31.
//

import UIKit
import SnapKit
import Then

class GrayBackgroundView: UICollectionReusableView {
    
    private let grayBackgroundView = UIView().then {
        $0.backgroundColor = .systemBackground 
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        addSubview(grayBackgroundView)
        
        grayBackgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
