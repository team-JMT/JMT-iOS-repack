//
//  AutoSizingCollectionView.swift
//  JMTeng
//
//  Created by PKW on 3/11/24.
//

import UIKit

class AutoSizingCollectionView: UICollectionView {
   
    override func layoutSubviews() {
        super.layoutSubviews()
    
        // bounds가 intrinsicContentSize와 다르면 invalidateIntrinsicContentSize를 호출
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        // 현재 콘텐츠 사이즈를 intrinsicContentSize로 반환
        return contentSize
    }
}

