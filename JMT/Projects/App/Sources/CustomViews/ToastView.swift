//
//  ToastView.swift
//  JMTeng
//
//  Created by PKW on 3/26/24.
//

import UIKit
import Toast_Swift

class ToastView: UIView {

    @IBOutlet weak var toastImageView: UIImageView!
    @IBOutlet weak var toastLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        layer.cornerRadius = 8
        layer.shadowColor = UIColor(red: 0.086, green: 0.102, blue: 0.114, alpha: 0.08).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2) // 위치조정
        layer.shadowRadius = 16 // 반경
        layer.shadowOpacity = 1 // alpha값
        
        frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 56)
    }
}
