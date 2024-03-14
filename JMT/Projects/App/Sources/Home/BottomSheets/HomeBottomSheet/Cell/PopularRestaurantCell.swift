//
//  PopularRestaurantCell.swift
//  JMTeng
//
//  Created by PKW on 2024/02/14.
//

import UIKit
import SkeletonView
import Kingfisher

class PopularRestaurantCell: UICollectionViewCell {
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        isSkeletonable = true
        skeletonCornerRadius = 20
        
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height / 2
        
        // 셀의 레이아웃이 결정된 후 그림자 속성 설정
        layer.shadowColor = JMTengAsset.gray200.color.cgColor // 그림자 색상
        layer.shadowOpacity = 1 // 그림자 투명도
        layer.shadowOffset = CGSize(width: 0, height: 4) // 그림자 오프셋
        layer.shadowRadius = 16 // 그림자 블러 반경
        
        layer.masksToBounds = false
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true // 콘텐츠 뷰 내부의 콘텐츠는 마스크 적용
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        restaurantImageView.image = nil
        userProfileImageView.image = nil
        userNicknameLabel.text = ""
        restaurantNameLabel.text = ""
    }
    
    func setupData(model: SearchMapRestaurantItems?) {
        
        if let model = model {
            if let url = URL(string: model.restaurantImageUrl ?? "") {
                restaurantImageView.kf.setImage(with: url)
            } else {
                restaurantImageView.image = JMTengAsset.emptyResult.image
            }
            
            if let url = URL(string: model.userProfileImageUrl ?? "") {
                userProfileImageView.kf.setImage(with: url)
            } else {
                userProfileImageView.image = JMTengAsset.emptyResult.image
            }

            userNicknameLabel.text = model.userNickName
            restaurantNameLabel.text = model.name
            
            
        } else {
            // 모델이 nil일 때 기본 이미지와 텍스트로 초기화
            restaurantImageView.image = nil // 또는 다른 기본 이미지
            userProfileImageView.image = nil // 또는 다른 기본 이미지
            userNicknameLabel.text = ""
            restaurantNameLabel.text = ""
        }
    }
}



