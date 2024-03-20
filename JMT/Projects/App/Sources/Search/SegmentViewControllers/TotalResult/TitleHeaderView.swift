//
//  TitleHeaderView.swift
//  JMTeng
//
//  Created by PKW on 2024/01/31.
//

import UIKit

class TitleHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowButton: UIButton!
    
    // 이 메서드는 스토리보드에서 이 클래스의 인스턴스를 만들 때는 호출되지 않습니다.
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // 여기에 필요한 초기화 코드를 추가할 수 있습니다.
    }
    
      
    func setupTitle(title: String) {
        titleLabel.text = title
    }
}
