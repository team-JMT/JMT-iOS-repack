//
//  CollectionBackgroundGrayView.swift
//  JMTeng
//
//  Created by PKW on 3/25/24.
//

import Foundation
import UIKit
import SnapKit

class CollectionBackgroundGrayView: UICollectionReusableView {
    
//    private let backgroundView = UIView().then {
//        $0.backgroundColor = JMTengAsset.gray100.color
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = JMTengAsset.gray100.color
//        addSubview(backgroundView)
//        
//        backgroundView.snp.makeConstraints {
//            $0.top.leading.trailing.equalToSuperview()
//            $0.bottom.equalToSuperview()
//        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
