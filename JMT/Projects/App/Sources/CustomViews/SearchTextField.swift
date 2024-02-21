//
//  SearchTextField.swift
//  JMTeng
//
//  Created by PKW on 2024/01/30.
//

import UIKit

class SearchTextField: UITextField {

    // 초기화 메소드
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextField()
    }
    
    func setupTextField() {
        self.backgroundColor = JMTengAsset.gray100.color
        self.layer.cornerRadius = 8
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        
        self.leftView = leftPaddingView
        self.leftViewMode = .always
        
        self.rightView = rightPaddingView
        self.rightViewMode = .always
        
    }
        

}
