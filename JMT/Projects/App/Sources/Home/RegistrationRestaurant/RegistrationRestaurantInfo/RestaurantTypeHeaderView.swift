//
//  RestaurantTypeHeaderView.swift
//  JMTeng
//
//  Created by PKW on 2024/02/05.
//

import UIKit

protocol RestaurantTypeHeaderViewDelegate {
    func didTabChangeTypeButton()
}

class RestaurantTypeHeaderView: UICollectionReusableView {
        
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var restaurantTypeImageView: UIImageView!
    @IBOutlet weak var restaurantTypeLabel: UILabel!
    @IBOutlet weak var restaurantCheckImageView: UIImageView!
    
    var delegate: RestaurantTypeHeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 8
        containerView.layer.shadowColor = UIColor(red: 0.086, green: 0.102, blue: 0.114, alpha: 0.08).cgColor // 그림자 색상 설정
        containerView.layer.shadowOpacity = 1 // 그림자 투명도 설정
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4) // 그림자 위치 설정
        containerView.layer.shadowRadius = 16 // 그림자 블러 정도 설정
            
            // 그림자가 잘리지 않도록 클리핑을 비활성화합니다.
        containerView.layer.masksToBounds = false
        self.layer.masksToBounds = false
    }
    
    @IBAction func didTabChangeTypeButton(_ sender: Any) {
        delegate?.didTabChangeTypeButton()
    }
    
    func updateTypeLabel(text: String) {
        restaurantTypeLabel.text = text
    }
    
    func updateTypeHeaderView() {
        headerStackView.spacing = 8
        restaurantTypeImageView.isHidden = false
        restaurantCheckImageView.image = JMTengAsset.restaurantTypeCheck.image
    }
}
